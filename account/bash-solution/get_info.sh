#!/bin/bash
set -e

is_contract () {
    bytecode=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["'$address'", "latest"],"id":1}' $host_name | jq -r .result)
   
    echo -e "ByteCode: $bytecode"

    if [ "$bytecode" = "0x" ];
    then
        echo "Address is NOT a contract"
    else
        echo "Address IS a contract"
    fi
}

get_full_state () {
    nonce=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["'$address'","latest"],"id":1}' $host_name | jq -r .result | xargs printf "%f")
    
    balance_in_wei=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$address'", "latest"],"id":1}' $host_name | jq -r .result | xargs printf "%f")
    
    code=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["'$address'", "latest"],"id":1}' $host_name | jq -r .result)

    echo -e "\nNonce: $nonce\nBalance in Wei: $balance_in_wei\nByteCode: $code"

}


project_id="YOUR-PROJECT-ID"
host_name="https://rinkeby.infura.io/v3/$project_id"


# address of a verified contract on rinkeby https://rinkeby.etherscan.io/address/0x4dABe5fd289B0Dd4eC3AdF46A1B394aa09c7a459#code
# address = "0x4dABe5fd289B0Dd4eC3AdF46A1B394aa09c7a459"

# address of my personal account (test account) - nonce should be 13
# address = "0x864e4b0c28dF7E2f317FF339CebDB5224F47220e"

address="0x4dABe5fd289B0Dd4eC3AdF46A1B394aa09c7a459"

is_contract
get_full_state