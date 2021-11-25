const fs = require('fs');
const snowflake = require('snowflake-sdk');

const SF_PREFIX = `${process.env.SF_DATABASE}.${process.env.SF_SCHEMA_PREFIX}`;

const connection = snowflake.createConnection( {
    account: process.env.SNOWSQL_ACCOUNT,
    username: process.env.SNOWSQL_USER,
    password: process.env.SNOWSQL_PWD,
    database: process.env.SF_DATABASE,
    schema: process.env.SF_SCHEMA
});

connection.connect((err) => {
    if (err) {
        console.error(`Unable to connect: ${err.message}`);
    } else {
        // Optional: store the connection ID.
        //const connection_ID = conn.getId();
    }
});

function execAsync (query) {
    return new Promise((resolve, reject) => {
        connection.execute({
            sqlText: query,
            complete: (err, stmt, rows) => {
                if (err) {
                    return reject(err);
                }
                return resolve(rows);
            }
        });
    });
}

async function runQuery (query) {
    query = query.replace(/@@SF_PREFIX@@/g, SF_PREFIX);
    const rows = await execAsync(query);
    return rows;
}

async function createTable (tablename, filepath) {
    const sql = fs.readFileSync(filepath);
    const query = `
      CREATE TABLE IF NOT EXISTS ${tablename} AS ${sql}
    `;
    await execAsync(query);
}

async function deleteTable (tablename) {
    const query = `
      DROP TABLE IF EXISTS ${tablename}
    `;
    await execAsync(query);
}

function sortByKey (list, key) {
    return list.sort((a, b) => (a[key] > b[key]) ? 1 : -1);
}

module.exports = {
    runQuery,
    createTable,
    deleteTable,
    sortByKey
}