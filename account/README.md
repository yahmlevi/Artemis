general solution - account creation:

1. Generate a private key (just a random number from a solid source of entropy)

2. Use Elliptical Curve cryptography to generate a public key from the private key (Trapdoor function (https://en.wikipedia.org/wiki/Trapdoor_function))

3. For public address - Hash the public key, take last 20 bytes, add 0x in the beginning


Elliplic Curve Cryptography (ECC) relies on:
    - some mathematical field (parametrized by h, p and n)
    - some elliptic curve (parametrized by a and b)
    - some point on the curve (parametrized by g = (x,y)) 

In Ethereum, the chosen parameters are those of the 'secp256k1' standard curve and are given here (https://www.secg.org/sec2-v2.pdf?ref=hackernoon.com).


Notes:
    - 'keccak-256sum' executable is for hashing with Bash 

Solution Walkthrough:

1. clone repo

2. run 'docker-compose up -d' when in repo dir

3. enter into workspace container with 'docker exec -it python-workspace bash'

4. creating a new account:

    4.1. Python & Web3 solution:
            - 'cd' into 'python-solution'
            - run 'python account_creation.py' 

    4.2. Bash & OpenSSL solution:
            - 'cd' into 'bash-solution'
            - run 'bash account_creation.sh'

5. verify if address is EOA/contract & get it's full state

    5.1. Python & Web3 solution:
            - 'cd' into 'python-solution'
            - run 'python get_info.py'

    5.2. Bash & OpenSSL solution:
            - 'cd' into 'bash-solution'
            - run 'bash get_info.sh'