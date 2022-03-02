// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Roulette {
    uint public pastBlockTime;
     
    // Initially fund contract
    constructor() payable {} 

    // call spin and send 1 ether to play
    function spin() public payable {     
        require(msg.value == 1 ether);
        // require only 1 transaction per block
        require(now != pastBlockTime);    
        // now is an alias for block.timestamp
        pastBlockTime = now;     
        // if the now/block.timestamp is divisible by 7 you win the Ether in the contract
        if(now % 7 == 0) {         
            msg.sender.transfer(this.balance);              
        } 
    }
}