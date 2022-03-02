import json
from web3 import Web3
import asyncio

# Rinkeby setup
# ----------------
infura_url_rinkeby = 'https://rinkeby.infura.io/v3/ff43de2d16d549f6936bf4f63d7a89ed'
web3_rinkeby = Web3(Web3.HTTPProvider(infura_url_rinkeby))

# address of the bridge contract on Rinkeby
rinkeby_bridge = '0xB1997Dec2532659b853F4b4478Cefb995388896d'
with open("/Artemis/cross_chain_bridges/contract_abi_rinkeby.json", mode='r') as abi_file_rinkeby:
    rinkeby_bridge_abi = json.load(abi_file_rinkeby)

rinkeby_bridge_contract = web3_rinkeby.eth.contract(address=rinkeby_bridge, abi=rinkeby_bridge_abi)

# Goerli setup
# ----------------
infura_url_ropsten = 'https://ropsten.infura.io/v3/22edf2ab03f042cda0314b126fb6d845'
web3_ropsten = Web3(Web3.HTTPProvider(infura_url_ropsten))

# address of the bridge contract on Ropsten
ropsten_bridge = '0x00b0330cbB374e1F1a6Bf41A17C9712114d56091'
with open("/Artemis/cross_chain_bridges/contract_abi_goerli.json", mode='r') as abi_file_goerli:
    ropsten_bridge_abi = json.load(abi_file_goerli)

ropsten_bridge_contract = web3_ropsten.eth.contract(address=ropsten_bridge, abi=ropsten_bridge_abi)

# Admin account setup
# ----------------
admin_address = Web3.toChecksumAddress('0x16cAD91E1928F994816EbC5e759d8562aAc65ab2')
admin_private_key = '0x8d735f1d490d53188fe1e3638e83417cfd6363df5cedea0da87fa186154b5fdd'
admin_address_nonce = web3_ropsten.eth.getTransactionCount(admin_address)

# once the event is found, handle it
def handle_event(event):
    # manipulate event result so it's comfertable to extract data from it
    str_object = Web3.toJSON(event)
    json_object = json.loads(str_object)
    
    # extract data from event
    from_address = Web3.toChecksumAddress(json_object["args"]["from"])
    to_address = Web3.toChecksumAddress(json_object["args"]["to"])
    amount = int(json_object["args"]["amount"])
    nonce = int(json_object["args"]["nonce"]) + 1
    
    # call the bridge contract's Mint function on Ropsten
    function_call = ropsten_bridge_contract.functions.mint(from_address, to_address, amount, nonce).buildTransaction({'chainId': 3, 'from': admin_address, 'nonce': admin_address_nonce})
    
    # sign and send the transaction
    signed_txn = web3_ropsten.eth.account.signTransaction(function_call, admin_private_key)
    txn_hash = web3_ropsten.eth.sendRawTransaction(signed_txn.rawTransaction)
    receipt = web3_ropsten.eth.waitForTransactionReceipt(txn_hash)
    
    print("Minted {} tokens for {}" .format(amount, to_address))
    print("Transaction hash: {}" .format(txn_hash.hex()))
    print("Receipt: {}" .format(receipt))

# asynchronous defined function to loop
# this loop sets up an event filter and is looking for new entires for the "Transfer" event
# this loop runs on a poll interval
async def log_loop(event_filter, poll_interval): 
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        await asyncio.sleep(poll_interval)

# when main is called
# create a filter for the latest block and look for the "Transfer" event of the bridge contract
# run an async loop
# try to run the log_loop function above every 2 seconds
def main():
    event_filter = rinkeby_bridge_contract.events.Transfer.createFilter(fromBlock='latest')
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(
            asyncio.gather(
                log_loop(event_filter, 2)))
    finally:
        # close loop to free up system resources
        loop.close()

if __name__ == "__main__":
    main()