#!/bin/bash
set -e

# we can call our host by it's docker container name, which we give to it in docker-compose.yaml
host_name="http://ganache"
port="8545"

# address of account to get balance of.  Change this to your own address 
address="0x4B03E441C9213f1bFeE30eC127947D95f456e8C8"

# get response from node -> extract hexadecimal value of balance in wei -> convert value to decimal
balance_in_wei=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$address'", "latest"],"id":1}' $host_name:$port | jq -r .result | xargs printf "%f")

# divide by 10 ** 18 to convert wei to ether
balance_in_ether=$(echo "$balance_in_wei/1000000000000000000" | bc)


echo -e "\nbalance in wei: $balance_in_wei"
echo -e "balance in Ether: $balance_in_ether"
