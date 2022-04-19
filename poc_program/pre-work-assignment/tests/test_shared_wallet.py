from brownie import accounts, SharedWallet, Wei
import brownie

class TestWallet():

    def set_up(self):
        """Set up the shared wallet and the owners."""

        self.og_owner = accounts[0]
        self.new_owner = accounts[1]
        self.shared_wallet = SharedWallet.deploy(2, 5, {'from': self.og_owner})
        self.fund_wallet()
        self.shared_wallet.addOwner(self.new_owner, {'from': self.og_owner})

    def fund_wallet(self):
        """Fund the wallet with 10 ether."""
        return self.og_owner.transfer(self.shared_wallet.address, Wei('10 ether'))

    def test_deposit_funds(self):
        """Test that the wallet receives funds as expected."""

        self.set_up()

        assert self.shared_wallet.balance() == Wei('10 ether') 

    def test_add_owner(self):
        """Test that the OG owner can add a new owner to the shared wallet, and that the recordings are updated accordingly."""

        self.set_up()
        
        assert self.shared_wallet.ownersIndex() == 1
        assert self.shared_wallet.validOwners(self.new_owner) == 1

    def test_remove_owner(self):
        """Test that the OG owner can remove a new owner from the shared wallet, and that the recordings are updated accordingly."""

        self.set_up()

        self.shared_wallet.removeOwner(self.new_owner, {'from': self.og_owner})

        assert self.shared_wallet.ownersIndex() == 0
        assert self.shared_wallet.validOwners(self.new_owner) == 0
    
    def test_withdraw(self):
        """Test that the a transaction initiator can withdraw funds from the shared wallet."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})
        self.shared_wallet.confirmTransaction({'from': self.new_owner})
        self.shared_wallet.confirmTransaction({'from': self.og_owner})
        self.shared_wallet.withdraw({'from': self.new_owner})

        assert self.new_owner.balance() == Wei('110 ether')
        assert self.shared_wallet.isOnGoingRequest() == False
    
    def test_withdraw_not_requester(self):
        """Test that only a transaction initiator can withdraw his approved funds."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})
        self.shared_wallet.confirmTransaction({'from': self.new_owner})
        self.shared_wallet.confirmTransaction({'from': self.og_owner})

        with brownie.reverts('You are not the requester!'):
            self.shared_wallet.withdraw({'from': self.og_owner})
        
        assert self.shared_wallet.balance() == Wei('10 ether')
        assert self.shared_wallet.isOnGoingRequest() == True
    
    def test_withdraw_not_confirmed(self):
        """Test that a withdraw can't happen without enough confirmations."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})

        with brownie.reverts('Not enough confirmations!'):
            self.shared_wallet.withdraw({'from': self.new_owner})
        
        assert self.shared_wallet.balance() == Wei('10 ether')
        assert self.shared_wallet.isOnGoingRequest() == True
    
    def test_revoke_transaction(self):
        """Test that a transaction initiator can revoke his request."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})
        self.shared_wallet.revokeRequest({'from': self.new_owner})

        assert self.shared_wallet.isOnGoingRequest() == False
    
    def test_revoke_transaction_not_requester(self):
        """Test that only the transaction initiator can revoke his own request."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})

        with brownie.reverts('You can\'t revoke someone else\'s request!'):
            self.shared_wallet.revokeRequest({'from': self.og_owner})
        
        assert self.shared_wallet.isOnGoingRequest() == True
    
    def test_reset_transaction_request(self):
        """Test that a transaction intinializtion can be reseted if the initiator is not a owner anymore."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})
        self.shared_wallet.removeOwner(self.new_owner, {'from': self.og_owner})
        self.shared_wallet.resetRequest({'from': self.og_owner})

        assert self.shared_wallet.isOnGoingRequest() == False
    
    def test_reset_transaction_of_exsisting_owner(self):
        """Test that a transaction initialization can't be reseted if the initiator is a valid owner."""

        self.set_up()

        self.shared_wallet.askToTransact(Wei('10 ether'), {'from': self.new_owner})

        with brownie.reverts('You can\'t reset a valid owner\'s request!'):
            self.shared_wallet.resetRequest({'from': self.og_owner})

        assert self.shared_wallet.isOnGoingRequest() == True