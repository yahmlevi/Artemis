from web3 import Web3

def is_contract(_address):
    print("Checking if the address is a contract or an EOA...")

    # hashed bytecode of a non-contract account (EOA - externally owned account)
    eoa_hash = '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
    
    # check if hashed bytecode of the address is equal to the hashed bytecode of a non-contract account
    if w3.keccak(hexstr = w3.eth.get_code(_address).hex()).hex() == eoa_hash:
        return False
    else:
        return True

def get_full_state(_address):
    # stateRoot

    # get nonce
    nonce = w3.eth.get_transaction_count(_address)

    # get balance of account in Wei
    balance_in_wei = w3.eth.get_balance(address)

    # convert balance from Wei to Ether
    balance_in_ether = Web3.fromWei(balance_in_wei, 'ether')

    # get hash of contracrs's ByteCode (EOA will have empty bytecode)
    code_hash = w3.keccak(hexstr = w3.eth.get_code(_address).hex()).hex()
    
    return nonce, balance_in_ether, code_hash


# connect to the Rinkeby network via Infura
project_id = "ff43de2d16d549f6936bf4f63d7a89ed"
host_name = "https://rinkeby.infura.io/v3/" + project_id

# address of a verified contract on rinkeby https://rinkeby.etherscan.io/address/0x4dABe5fd289B0Dd4eC3AdF46A1B394aa09c7a459#code
# address = "0x4dABe5fd289B0Dd4eC3AdF46A1B394aa09c7a459"

# address of my personal account (test account) - nonce should be 13
address = "0x864e4b0c28dF7E2f317FF339CebDB5224F47220e"

# set connection to node
w3 = Web3(Web3.HTTPProvider('https://rinkeby.infura.io/v3/ff43de2d16d549f6936bf4f63d7a89ed'))

print("Is address a contract? ", is_contract(address))

nonce, balance_in_ether, code_hash = get_full_state(address)
print("nonce: {}\nbalance in Ether: {}\nhashed ByteCode: {}" .format(nonce, balance_in_ether, code_hash))
