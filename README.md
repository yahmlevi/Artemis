TASK - get balance of an account using JSON-RPC API, denominated in Ether.

Solution Walkthrough:

1. clone repo.

2. run 'docker-compose up -d' when you are in the repo directory.

3. enter into workspace container with 'docker exec -it python-brownie-workspace bash'.

4. get an address of an account using 'docker logs ganache' on another terminal. the account has 100 fake Ether in it.

    Curl Solution:

        1. in curl_solution.sh, replace the address in line #9 with the one you got in step #4.

        2. run './curl_solution.sh'.
    
    Web3 (Python) Solution:
    
        1. in web3_solution.py, replace the address in line #8 with the one you got in step #4.

        2. run 'python web3_solution.py' from /web3_academy.
    
    Brownie Console Solution:

        1. instead of letting Brownie spin-up it's own Ganache blockchain, we will use the standalone one we created in docker-compose file.

        2. run 'brownie networks add development web3-blockchain cmd=ganache-cli host=http://ganache port=8545', now we can see our standalone ganache blockchain when running 'brownie networks list'.

        3. to enter into brownie console, run 'brownie console --network web3-blockchain'.

        4. we have access to all the accounts Ganache created for us (the ones from Ganache's log), by running 'brownie accounts'. we can also add accounts by address using 'accounts.at(ACCOUNT_ADDRESS, force=True)'

        5. we can get the balance in wei of the first account by running 'accounts[0].balance()', and get it in Ether by dividing by 1e18 'accounts[0].balance() / (10 ** 18)'.

    Web Browser Solution:

        1. enter your favorite browser and go to it's 'developer tools --> console' (in Chrome,  more tools -> developer tools -> console).

        2. we can call our Ganache node using JSON-RPC with 'await fetch('http://localhost:8545', {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({"method":"eth_getBalance","params":["TARGET_ADDRESS", "latest"],"id":1,"jsonrpc":"2.0"})}).then((response) => response.json()).then((result) => {console.log(parseInt(result.result, 16) / 10 ** 18);});' - note to replace 'TARGET_ADDRESS' with the address you got in step #4.
        
8. run 'docker-compose down' to stop the containers.