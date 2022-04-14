// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {

    // data layout on the proxy contract should match the layout in the 'downstream' contracts (i.e. the contracts that are being proxied)
    // more info in accepted answer https://ethereum.stackexchange.com/questions/90917/delegate-call-msg-sender-wrong-value
    uint public favoriteNumber;

    event Delegated(
        bool success,
        bytes data
    );
    
    function setFavoriteNumber(address _contract, uint _num) public {
        // calls the function setFavoriteNumber on _contract in a delegated way, including arguments
        // the delegate call will produce 2 outputs; success if there are no errors and the output of the function in bytes 
        (bool success, bytes memory data) = _contract.delegatecall(abi.encodeWithSignature("setFavoriteNumber(uint256)", _num));
        
        emit Delegated(success, data);
    }
}