py solution - https://hackernoon.com/how-to-build-a-minimalistic-ethereum-wallet-in-python-part-1-rr4j32dp
sh solution - https://kobl.one/blog/create-full-ethereum-keypair-and-address/?ref=hackernoon.com


general solution:

1. Generate a private key (just a random number from a solid source of entropy)

2. Use Elliptical Curve cryptography to generate a public key from the private key (Trapdoor function (https://en.wikipedia.org/wiki/Trapdoor_function))

3. For public address - Hash the public key, take last 20 bytes, add 0x in the beginning


Elliplic Curve Cryptography (ECC) relies on:
    - some mathematical field (parametrized by h, p and n)
    - some elliptic curve (parametrized by a and b)
    - some point on the curve (parametrized by g = (x,y)) 

In Ethereum, the chosen parameters are those of the 'secp256k1' standard curve and are given here (https://www.secg.org/sec2-v2.pdf?ref=hackernoon.com).


solution walkthrough:

1. clone repo

2. run 'docker-compose up -d' when in repo dir

3. enter into workspace container with 'docker exec -it python-workspace bash'

    Python & Web3 solution:
        - 

    Bash & OpenSSL solution:
        -