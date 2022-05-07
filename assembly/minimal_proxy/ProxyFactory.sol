// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract ProxyFactory{
    
    // Create proxy contracts based on https://eips.ethereum.org/EIPS/eip-1167
    function createProxy(address logicContractAddress) public returns(address result){
        
        bytes20 addressBytes = bytes20(logicContractAddress);
        assembly{
            
            // Jump to the end of the currently allocated memory - 0x40 is the free memory pointer. It allows us to add our own code
            let clone:= mload(0x40)
                        
            // store 32 bytes (0x3d602...) to memory starting at the position clone
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)

            // add the address at the location clone + 20 bytes. 0x14 is 20 in decimal
            mstore(add(clone, 0x14), addressBytes)
            
            // add the rest of the code at position 40 bytes (0x28 = 40)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
           
            // return the address of the newly created proxy
           result := create(0, clone, 0x37)
        }
    }
}