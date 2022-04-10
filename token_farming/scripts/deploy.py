from brownie import accounts, RewardDistributor, TokenArtemis

def deploy_contracts():
    account = accounts[0]
    print(account)
    
    token_artemis = TokenArtemis.deploy("Yahm", "YHM", {'from': account})
    print(token_artemis)

    reward_distributor = RewardDistributor.deploy(token_artemis, {'from': account})
    print(reward_distributor)

    transaction = token_artemis.updateAdmin(reward_distributor, {'from': account})
    transaction.wait(1)
    
def main():
    deploy_contracts()