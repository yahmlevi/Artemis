from web3 import Web3

def is_contract(_address):
    print("Checking if the address is a contract or an EOA...")

    # hashed bytecode of a non-contract account (EOA - externally owned account)
    eoa_hash = '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
    
    # check if hashed bytecode of the address is equal to the hashed bytecode of a known non-contract account
    if w3.keccak(hexstr = w3.eth.get_code(_address).hex()).hex() == eoa_hash:
        return False
    else:
        return True


# set Infura details for Goerli network
project_id = "ff43de2d16d549f6936bf4f63d7a89ed"
host_endpoint = "https://goerli.infura.io/v3/" + project_id

# address of a verified contract on Goerli https://goerli.etherscan.io/address/0xE7a0eDfFf12b8FEBbD0f94B0936C2B1F43b61f84#code
# address = "0xE7a0eDfFf12b8FEBbD0f94B0936C2B1F43b61f84"

# address of my personal test account - nonce should be 1
# address = "0x864e4b0c28dF7E2f317FF339CebDB5224F47220e"

# set target address
address = "0xE7a0eDfFf12b8FEBbD0f94B0936C2B1F43b61f84"

# set connection to Goerli node via Infura
w3 = Web3(Web3.HTTPProvider(host_endpoint))

# execute is_contract function to check if the address is a contract or an EOA
print("\n\nIs address a contract? ", is_contract(address))

# execute Python's Web3 get_proof function to get the current full state of the contract
full_state = w3.eth.get_proof(address, [0], "latest")
print("\n\nfull state: ", full_state)
