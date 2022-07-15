# subnational-indicators

This repository generates an RDF data cube from data used in the the ONS' [subnational indicators explorer](https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/articles/subnationalindicatorsexplorer/2022-01-06).

- The original data provided by the ONS team is located in [`data`](./raw-data) folder.
- [`main.R`](./main.R) edits the original data into a format suitable for generation into an RDF data cube ([`20220331-subnational-indicators.csv`](./data/20220331-subnational-indicators.csv)).
- The [`data`](./data) folder contains the output of this transform, the [accompanying CSVW metadata](./data/20220331-subnational-indicators.csv-metadata.json) and the [turtle output](./data/20220331-subnational-indicators.ttl) which was created by running `csv2rdf` over the CSVW.
- The [reference-data](./reference-data) folder contains all associated catalogue metadata and codelists.
- [`deploy.sh`](./deploy.sh) uses the drafter API to upload the RDF to PMD.


[`csv2rdf`](https://github.com/Swirrl/csv2rdf) was run over the CSVW with the following command:

```sh
docker run --rm -v $PWD:/workspace -w /workspace -it gsscogs/csv2rdf \
csv2rdf -u data/20220331-subnational-indicators.csv-metadata.json -m annotated -o data/20220331-subnational-indicators.ttl
```

[`deploy.sh`](./deploy.sh)  assumes a drafter `CLIENT_ID` and `CLIENT_SECRET` are set in a `.env` file which is available to the script.

```sh
# .env -------------------------------------
export CLIENT_ID="<your-client-id>";
export CLIENT_SECRET="<your-client-secret>";
```