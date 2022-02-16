#!/bin/bash
set -e

is_contract () {
    # call the Goerli network endpoint with Ethereum's eth_getCode JSON-RPC method and pass to it a target address and a block number
    # extract the result and assign to a variable named 'bytecode'
    bytecode=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["'$address'", "latest"],"id":1}' $host_endpoint | jq -r .result)
   
    # if bytecode is not empty, then it is a contract
    # we could also hash the bytecode and compare to a known non-contract hash, like in get_info.py
    if [ "$bytecode" = "0x" ];
    then
        printf "\n\nAddress is NOT a contract\n\n"
    else
        printf "\n\nAddress IS a contract\n\n"
    fi
}

# set Infura details for Goerli network
project_id="ff43de2d16d549f6936bf4f63d7a89ed"
host_endpoint="https://goerli.infura.io/v3/$project_id"


# address of a verified contract on Goerli https://goerli.etherscan.io/address/0xE7a0eDfFf12b8FEBbD0f94B0936C2B1F43b61f84#code
# address = "0xE7a0eDfFf12b8FEBbD0f94B0936C2B1F43b61f84"

# address of my personal test account - nonce should be 1
# address = "0x864e4b0c28dF7E2f317FF339CebDB5224F47220e"

# set target address 
address="0xE7a0eDfFf12b8FEBbD0f94B0936C2B1F43b61f84"

# call is_contract function
is_contract

# assign the result of the eth_getProof RPC method to a variable named 'full_state'
# eth_getProof JSON-RPC method returns the full state of an account at a given block (nonce, balance, codeHash, stateRoot (first item in accountProof))
full_state=$(curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getProof","params":["'$address'", ["0"], "latest"],"id":1}' $host_endpoint)
printf "\n\n\nFull State: \n$full_state"