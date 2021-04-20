const assert = require('assert').strict;
const {BigQuery} = require('@google-cloud/bigquery');

const BQ_PROJECTID = process.env.BQ_PROJECTID;
const BQ_DATASET_MEASUREMENT = process.env.BQ_DATASET_MEASUREMENT;

describe('MEASUREMENT integration tests', () => {
    const queryOptions = { 'timeoutMs' : 30000 };
    let client;
    before(async () => {
        if (!BQ_PROJECTID) {
            throw "Missing BQ_PROJECTID env variable";
        }
        if (!BQ_DATASET_MEASUREMENT) {
            throw "Missing BQ_DATASET_MEASUREMENT env variable";
        }
        client = new BigQuery({projectId: `${BQ_PROJECTID}`});
    });

    it('Returns the proper version', async () => {
        const query = `SELECT \`${BQ_PROJECTID}\`.\`${BQ_DATASET_MEASUREMENT}\`.VERSION() as versioncol;`;
        let rows;
        await assert.doesNotReject(async () => {
            [rows] = await client.query(query, queryOptions);
        });
        assert.equal(rows.length, 1);
        assert.equal(rows[0].versioncol, '1.0.0');
    });
}); /* MEASUREMENT integration tests */
