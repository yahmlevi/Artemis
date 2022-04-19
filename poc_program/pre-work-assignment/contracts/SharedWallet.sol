// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SharedWallet {

    // Info about a requested transaction.
    struct TransactionInfo {
        address requester;
        uint256 amount;
        uint256 numberOfConfirmations;
    }

    TransactionInfo transactionInfo;

    // Contract creator and most powerful owner (only account that can add/remove owners).
    address public owner;
    // Required number of confirmations to initiate a transaction.
    uint256 public requiredConfirmations;
    // Number of owners, not including OG owner.
    uint256 public ownersIndex;
    // Maximum number of owners.
    uint256 public maxOwners;
    // Block number at which a request was initiated.
    uint256 public blockOnRequest;
    // Flag to indicate if a request is ongoing.
    bool public isOnGoingRequest;
    
    // Address of added owners (not including the OG owner).  
    mapping(address => uint8) public validOwners;
    // Address of a transaction approvers.
    mapping(address => uint256) public transactionApprovers; 

    // Allows only the Original Gangster owner.
    modifier ogOwner() {
        require(msg.sender == owner);
        _;
    }

    // Allows all owners (OG owner or added owner).
    modifier validOwner() {
        require(msg.sender == owner || validOwners[msg.sender] == 1);
        _;
    }

    event Deposit(address from, uint256 amount);
    event Withdraw(address from, uint256 amount);
    event RequestTransaction(address from, uint256 amount);
    event ConfirmTransaction(address from, address to);
    event RevokeRequest(address from);
    event ResetRequest(address from);

    // @param _requiredConfirmations Required number of confirmations to initiate a transaction.
    // @param _maxOwners Maximum number of owners.
    constructor(uint256 _requiredConfirmations, uint256 _maxOwners) public {
        owner = msg.sender;
        requiredConfirmations = _requiredConfirmations;
        maxOwners = _maxOwners;
    }

    // @notice Add an owner to the wallet.
    // @param _owner Address of the new owner.
    function addOwner(address _owner) public ogOwner {
        require(ownersIndex < maxOwners);
        require(validOwners[_owner] == 0, "Owner already exists");

        validOwners[_owner] = 1;
        ownersIndex += 1;
    }

    // @notice Remove an owner from the wallet.
    // @param _owner address of the owner to be removed.
    function removeOwner(address _owner) public ogOwner {
        require(validOwners[_owner] == 1, "Owner does not exist");

        validOwners[_owner] = 0;
        ownersIndex -= 1;
    }

    // @notice Anyone can deposit funds into the wallet and emit an event.
    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // @notice Withdraw funds from the wallet.
    function withdraw() public validOwner {
        require(isOnGoingRequest == true, "There no ongoing request!");
        require(transactionInfo.numberOfConfirmations >= requiredConfirmations, "Not enough confirmations!");
        require(transactionInfo.requester == msg.sender, "You are not the requester!");
        require(address(this).balance >= transactionInfo.amount, "Not enough funds!");

        isOnGoingRequest = false;
        payable(msg.sender).transfer(transactionInfo.amount);

        emit Withdraw(msg.sender, transactionInfo.amount);
    }

    // @notice Initiate a request to transact.
    // @param _amount Amount of funds to be transferred.
    function askToTransact(uint256 amount) public validOwner {
        require(isOnGoingRequest == false, "There is already an ongoing request!");
        
        transactionInfo.requester = msg.sender;
        transactionInfo.amount = amount;
        transactionInfo.numberOfConfirmations = 0;
        
        isOnGoingRequest = true;
        blockOnRequest = block.number;

        emit RequestTransaction(msg.sender, amount);
    }

    // @notice Confirm a transaction request.
    function confirmTransaction() public validOwner {
        require(isOnGoingRequest == true, "There is no ongoing request!");
        require(transactionApprovers[msg.sender] <= blockOnRequest, "You have already confirmed this transaction!");
    
        transactionInfo.numberOfConfirmations += 1;
        transactionApprovers[msg.sender] = block.number;

        emit ConfirmTransaction(msg.sender, transactionInfo.requester);
    }

    // @notice Cancel a transaction request.
    function revokeRequest() public validOwner {
        require(isOnGoingRequest == true, "There is no ongoing request!");
        require(transactionInfo.requester == msg.sender, "You can't revoke someone else's request!");
        
        isOnGoingRequest = false;

        emit RevokeRequest(msg.sender);
    }

    // @notice Reset a transaction request.
    function resetRequest() public validOwner {
        require(isOnGoingRequest == true, "There is no ongoing request!");
        require(validOwners[transactionInfo.requester] == 0, "You can't reset a valid owner's request!");
        
        isOnGoingRequest = false;

        emit ResetRequest(msg.sender);
    }

    // @notice Get the number of confirmations.
    function getNumberOfConfirmations() public view validOwner returns (uint256) {
        return transactionInfo.numberOfConfirmations;
    }

    // @notice Get the requester.
    function getRequester() public view validOwner returns (address) {
        return transactionInfo.requester;
    }
}
