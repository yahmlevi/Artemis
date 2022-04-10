from brownie import accounts, RewardDistributor, RewardToken

def test_pro_rate_distribution():
    account = accounts[0]
    
    # deploy contracts
    token_artemis = RewardToken.deploy("Reward Token", "RWRD", {'from': account})
    reward_distributor = RewardDistributor.deploy(token_artemis, {'from': account})

    # update admin for RewardToken, and wait for transaction to be mined (wait 1 block)
    update_admin_transaction = token_artemis.updateAdmin(reward_distributor, {'from': account})
    update_admin_transaction.wait(1)

    # execute joinList function in RewardDistributor, and wait for transaction to be mined (wait 1 block)
    joinList_transaction = reward_distributor.joinList({'from': account})
    joinList_transaction.wait(1)

    # execute withdraw function in RewardDistributor, and wait for transaction to be mined (wait 1 block)
    withdraw_transaction = reward_distributor.withdraw({'from': account})
    withdraw_transaction.wait(1)
    
    # get RewardToken balance of account
    account_balance = token_artemis.balanceOf(account)
    
    # balanceOf 'account' should be 10 * 10**18, as RewardDistributor contract distributes 10 tokens per block
    # and we wirhdrawed after just 1 block 
    assert account_balance == 10 * 10**18