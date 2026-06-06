#!/bin/bash

TOKEN="8865071374:AAGFPtCddeE1N7J90h54BpDnz5ODKuaaVKc"
CHAT_ID="575414825"
test= "$1"

curl -s \
  -X POST \
  "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="🚨 Movimento rilevato ${test}"
