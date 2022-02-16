#!/bin/bash
set -e

# generate elliptic curve key pair (first, the private key, then the public key from the private key) and save output to a file named 'KeyPair'
openssl ecparam -name secp256k1 -genkey -noout | openssl ec -text -noout > KeyPair

# clean the public key and save it to a file named 'PublicKey'
cat KeyPair | grep pub -A 5 | tail -n +2 | tr -d '\n[:space:]:' | sed 's/^04//' > PublicKey

# generate account address from public key
# hash the public key, clean the result and assign it to a variable named 'address'
address="0x$(cat PublicKey | keccak-256sum -x | tr -d ' -' | tail -c 41)"
printf "\naccount address: $address"

