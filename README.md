TASK - get balance the of an account using JSON-RPC API, denominated in Ether

solution walkthrough:

1. clone repo
2. run 'docker-compose up' when you are in the repo directory
3. get an address of an account using 'docker logs ganache' on another terminal. the account has 100 fake Ether in it 
4. in 1st_solution_curl.sh and 2nd_solution_rpc_call.py, replace the address with the one you got in step 3
5. enter into workspace container with 'docker exec -it python-workspace bash'
6. to run the Curl script, run './1st_solution_curl.sh' from /web3_academy
7. to run the Python script, run 'python 2nd_solution_rpc_call.py' from /web3_academy