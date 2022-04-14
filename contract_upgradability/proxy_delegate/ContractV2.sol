// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract V2 {
    
    uint public favoriteNumber;
    
    function setFavoriteNumber(uint _num) public payable {
        favoriteNumber = _num * 2;
    }
}