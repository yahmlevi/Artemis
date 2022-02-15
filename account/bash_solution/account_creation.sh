#!/bin/bash
set -e

# generate elliptic curve key pair (first, the private key, then the public key from the private key) and save output to file named 'KeyPair'
openssl ecparam -name secp256k1 -genkey -noout | openssl ec -text -noout > KeyPair

# clean public key and save to file named 'PublicKey'
cat KeyPair | grep pub -A 5 | tail -n +2 | tr -d '\n[:space:]:' | sed 's/^04//' > PublicKey

# generate account address from public key
account_address="0x$(cat PublicKey | keccak-256sum -x | tr -d ' -' | tail -c 41)"
echo -e "\naccount address: $account_address"

