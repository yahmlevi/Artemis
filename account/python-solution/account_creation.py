from tinyec.ec import SubGroup, Curve
from Crypto.Random.random import randint
from web3 import Web3

# pre-defined parameters for the elliptic curve as detailed here (https://www.secg.org/sec2-v2.pdf?ref=hackernoon.com)
h = 1
p = int("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F", 16)
n = int("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", 16)
x = int("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798", 16)
y = int("483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8", 16)
g = (x,y)

# create Python objects corresponding to the mathematical field and the elliptic function
field = SubGroup(p, g, n, h)
curve = Curve(a = 0, b = 7, field = field, name = 'secp256k1')

# generate a random private key usuing PyCrypto library
private_key = randint(1, n)
print("random private key: " + str(private_key))

# generate a public key using the private key and the elliptic curve
public_key = private_key * curve.g
public_key_hex = Web3.toHex(public_key.x)[2:] + Web3.toHex(public_key.y)[2:]

# generate a valid Ethereum address using the public key and Keccak-256 hashing algorithm
address = Web3.keccak(hexstr = public_key_hex).hex()
address = "0x" + address[-40:]

# using a checksum to capitalize the address and protect against typos
address = Web3.toChecksumAddress(address)
print("public address: " + str(address))

