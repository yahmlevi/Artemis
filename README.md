TASK - get balance the of an account using JSON-RPC API, denominated in Ether


- spin-up a local ganache blockchain & workspace using provided docker-compose.yaml file with command 'docker-compose up', when current work dir is where docker-compose file and other relevent scripts (we can also use a personal Ethereum node or a node-provider service like infura.io for a blockchain endpoint).

1st solution:
- use any of the methods available in https://eth.wiki/json-rpc/API (specifically eth_getBalance method) using Curl.

2nd sulotion:
- use Python's Web3 library which leverages JSON-RPC (https://web3py.readthedocs.io/en/stable/web3.eth.html). make sure to install the Web3 package on your environment.
