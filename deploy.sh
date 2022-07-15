source .env;

token=$(curl --request POST \
  --url https://swirrl-staging.eu.auth0.com/oauth/token \
  --header "Content-Type: application/json" \
  --data '{
      "client_id": "'"${CLIENT_ID}"'",
      "client_secret": "'"${CLIENT_SECRET}"'",
      "audience": "https://pmd",
      "grant_type": "client_credentials"
    }' | jq -r '.access_token');

draftset=$(curl -w '%{redirect_url}' --request POST \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftsets" \
  --header "Authorization: Bearer ${token}" \
  -d display-name=subnational-indicators \
  -d description=subnational-indicators
);

id="${draftset##*/}"

curl --location --request PUT \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftset/${id}/data" \
  --header "Content-Type: application/trig" \
  --header "Authorization: Bearer ${token}" \
  --data @reference-data/catalogue.trig;

curl --location --request PUT \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftset/${id}/data" \
  --header "Content-Type: application/trig" \
  --header "Authorization: Bearer ${token}" \
  --data @reference-data/measure-type.trig;

curl --location --request PUT \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftset/${id}/data" \
  --header "Content-Type: application/trig" \
  --header "Authorization: Bearer ${token}" \
  --data @reference-data/misc.trig;

curl --location --request PUT \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftset/${id}/data" \
  --header "Content-Type: application/trig" \
  --header "Authorization: Bearer ${token}" \
  --data @reference-data/area.trig;

curl --location --request PUT \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftset/${id}/data" \
  --header "Content-Type: application/trig" \
  --header "Authorization: Bearer ${token}" \
  --data @reference-data/period.trig;

# create a temporary zip file
gzip -k data/20220331-subnational-indicators.ttl;

curl --location --request PUT \
  --url "https://cogs-staging-drafter.publishmydata.com/v1/draftset/${id}/data/graph?graph=http://data.gov.uk/dataset/subnational-indicators/datacube/graph" \
  --header "Content-Type: text/turtle" \
  --header "Content-Encoding: gzip" \
  --header "Authorization: Bearer ${token}" \
  --data @data/20220331-subnational-indicators.ttl.gz;

rm data/20220331-subnational-indicators.ttl.gz;