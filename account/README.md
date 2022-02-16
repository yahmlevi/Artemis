https://www.notion.so/Accounts-f2a5410ce64a4225a606b2d7b08d8c4c

solution:

    account creation:
        1. Generate a private key (just a random number from a solid source of entropy)

        2. Use Elliptical Curve cryptography to generate a public key from the private key (Trapdoor function (https://en.wikipedia.org/wiki/Trapdoor_function))

        3. For public address - Hash the public key, take last 20 bytes, add 0x in the beginning
    
    full state of account & check if it's a contract or an EOA:
        1. call Ethereum's JSON-RPC eth_getProof method to get the full state of the account (nonce, balance, codeHash, stateRoot (first item in accountProof))

        2. call Ethereum's JSON-RPC eth_getCode method to get the ByteCode of the account - hash the ByteCode, and compare result to the known hashed ByteCode of an EOA (0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470)

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
                - run './account_creation.sh'

    5. verify if address is EOA/contract & get it's full state

        5.1. Python & Web3 solution:
                - 'cd' into 'python-solution'
                - add your Infura project id to 'get_info.py'
                - run 'python get_info.py'

        5.2. Bash & OpenSSL solution:
                - 'cd' into 'bash-solution'
                - add your Infura project id to 'get_info.sh'
                - run './get_info.sh'



Notes:

    1. 'keccak-256sum' executable is for hashing with Bash
    
    2. notice different address in Python & Bash get_info solutions
    
    3. add your own Infura project ID to scripts



Elliptic Curve Cryptography (ECC) relies on:
    
    1. some mathematical field (parametrized by h, p and n)
    
    2. some elliptic curve (parametrized by x and y)
    
    3. some point on the curve (parametrized by g = (x,y)) 
    
    In Ethereum, the chosen parameters are those of the 'secp256k1' standard curve and are given here (https://www.secg.org/sec2-v2.pdf?ref=hackernoon.com).
