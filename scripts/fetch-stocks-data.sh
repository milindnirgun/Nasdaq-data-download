#!/bin/bash

# This script should be run in the root of Nasdaq-data-download

BASE_PATH=$(pwd)
DATE=$(TZ='America/New_York' date +'%Y-%m-%d')

curl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
  https://api.nasdaq.com/api/screener/stocks?tableonly\=true\&limit\=25\&offset\=0\&exchange\=nasdaq\&download\=true >/tmp/nasdaq.json
cat /tmp/nasdaq.json | jq '.data.rows' >$BASE_PATH/nasdaq/nasdaq_full_tickers-${DATE}.json

curl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
  https://api.nasdaq.com/api/screener/stocks?tableonly\=true\&limit\=25\&offset\=0\&exchange\=amex\&download\=true >/tmp/amex.json
cat /tmp/amex.json | jq '.data.rows' >$BASE_PATH/amex/amex_full_tickers-${DATE}.json

curl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
  https://api.nasdaq.com/api/screener/stocks?tableonly\=true\&limit\=25\&offset\=0\&exchange\=nyse\&download\=true >/tmp/nyse.json
cat /tmp/nyse.json | jq '.data.rows' >nyse/nyse_full_tickers-${DATE}.json
