// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract sharedWallet {

    struct RequestedTransaction {
        address requester;
        uint256 amount;
        uint256 numberOfConfirmations;
    }

    RequestedTransaction requestedTransaction;

    address public _owner;
    uint256 public requiredConfirmations;
    uint256 public ownersIndex;
    uint256 public maxOwners;
    uint256 public blockOnRequest;
    bool public isOnGoingRequest;

    // Mapping of owners. uint8 indicates if an owner exists 
    mapping(address => uint8) public _owners;

    // Mapping of transaction approvers. uint256 contains the block number at the time of approval 
    mapping(address => uint256) public approversMap; 

    // Original owner modifier (only account that can add/remove owners)
    modifier isOwner() {
        require(msg.sender == _owner);
        _;
    }

    // Secondery + original owner modifier
    modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender] == 1);
        _;
    }

    event eventDepositFunds(address from, uint256 amount);
    event eventWithdrawFunds(address from, uint256 amount);
    event eventaskToTransact(address from, uint256 amount);
    event eventconfirmTransaction(address from, address to);
    event eventrevokeRequest(address from);

    // Set (1) original owner, (2) required # of confirmations to initiate a transaction and (3) maximum # of owners
    constructor(uint256 _requiredConfirmations, uint256 _maxOwners) public {
        _owner = msg.sender;
        requiredConfirmations = _requiredConfirmations;
        maxOwners = _maxOwners;
    }

    // Add an owner to the wallet. Only the original owner can add secondery owners
    // Also make sure that # of owners is not greater than the maximum allowed
    function addOwner(address owner) public isOwner {
        require(ownersIndex < maxOwners);
        _owners[owner] = 1;
        ownersIndex += 1;
    }

    // Remove an owner from the wallet. Only the original owner can remove secondery owners
    function removeOwner(address owner) public isOwner {
        _owners[owner] = 0;
        ownersIndex -= 1;
    }

    // Fallback function - anyone can deposit funds into the wallet and emit an event
    fallback() external payable {
        emit eventDepositFunds(msg.sender, msg.value);
    }

    // Withdraw funds from the wallet
    // To withdraw you need to recieve enough confirmations from other owners, as set in the contract's constructor
    function withdraw() public validOwner {
        require(requestedTransaction.numberOfConfirmations >= requiredConfirmations, "Not enough confirmations");
        require(address(this).balance >= requestedTransaction.amount, "Not enough funds");
        require(isOnGoingRequest == true, "There no ongoing request");

        isOnGoingRequest = false;
        payable(msg.sender).transfer(requestedTransaction.amount);

        emit eventWithdrawFunds(msg.sender, requestedTransaction.amount);
    }

    // Ask other owners to transact
    // A request must be settled before asking again
    function askToTransact(uint256 amount) public validOwner {
        require(isOnGoingRequest == false, "There is already an ongoing request");
        
        // Initialize transaction request
        requestedTransaction.requester = msg.sender;
        requestedTransaction.amount = amount;
        requestedTransaction.numberOfConfirmations = 0;
        
        isOnGoingRequest = true;
        blockOnRequest = block.number;

        emit eventaskToTransact(msg.sender, amount);
    }

    // Cancel transaction request
    // Only the requester can cancel his request 
    function revokeRequest() public validOwner {
        require(isOnGoingRequest == true, "There is no ongoing request!");
        require(requestedTransaction.requester == msg.sender, "You can't revoke someone else's request!");
        
        isOnGoingRequest = false;

        emit eventrevokeRequest(msg.sender);
    }

    // Confirm transaction request
    // Only owners can confirm a request, and only once
    function confirmTransaction() public validOwner {
        require(isOnGoingRequest == true, "There is no ongoing request");
        require(approversMap[msg.sender] <= blockOnRequest, "You have already confirmed this transaction.");
    
        requestedTransaction.numberOfConfirmations += 1;
        approversMap[msg.sender] = block.number;

        emit eventconfirmTransaction(msg.sender, requestedTransaction.requester);
    }
}
