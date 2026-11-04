#!/bin/bash

# This script should be run in the root of Nasdaq-data-download

# Returns the date of the previous previous weekday (business day)
function get_previous_busday() {
  # Get the numeric day of the week (1 = Monday, 7 = Sunday)
  day_of_week=$(date +%u)

  case $day_of_week in
  1) # It's Monday, go back 3 days to Friday
    prev_weekday=$(TZ='America/New_York' date -d "3 days ago" +"%Y-%m-%d") ;;
  7) # It's Sunday, go back 2 days to Friday
    prev_weekday=$(TZ='America/New_York' date -d "2 days ago" +"%Y-%m-%d") ;;
  *) # Tue-Sat, just go back 1 day
    prev_weekday=$(TZ='America/New_York' date -d "1 day ago" +"%Y-%m-%d") ;;
  esac

}

get_previous_busday
DATE=$prev_weekday
echo "DATE=$DATE"
read -r -n 1 -s -p "Press any key to continue..."
echo ""

BASE_PATH=$(pwd)
#DATE=$(TZ='America/New_York' date +'%Y-%m-%d')

echo "$BASE_PATH/nasdaq/nasdaq_full_tickers-$DATE.json"
read -r -n 1 -s -p "Press any key to continue..."
echo ""

curl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
  https://api.nasdaq.com/api/screener/stocks?tableonly\=true\&limit\=25\&offset\=0\&exchange\=nasdaq\&download\=true >/tmp/nasdaq.json
cat /tmp/nasdaq.json | jq '.data.rows' >$BASE_PATH/nasdaq/nasdaq_full_tickers-${DATE}.json

curl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
  https://api.nasdaq.com/api/screener/stocks?tableonly\=true\&limit\=25\&offset\=0\&exchange\=amex\&download\=true >/tmp/amex.json
cat /tmp/amex.json | jq '.data.rows' >$BASE_PATH/amex/amex_full_tickers-${DATE}.json

curl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
  https://api.nasdaq.com/api/screener/stocks?tableonly\=true\&limit\=25\&offset\=0\&exchange\=nyse\&download\=true >/tmp/nyse.json
cat /tmp/nyse.json | jq '.data.rows' >nyse/nyse_full_tickers-${DATE}.json
