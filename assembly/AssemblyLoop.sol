// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

Contract AssemblyLoop {

    function regularLoop() public returns (uint _r) {
        for (uint i = 0; i < 10; i++) {
            _r++;
        }
    }

    function assemblyLoop() public returns (uint _r) {
        assembly {
            // Assign a value to parameter i.
            let i := 0
            // Define a loop. 
            loop:
            // Increment i by 1.
            i := add(i, 1)
            // Increment _r by 1.
            _r := add(_r, 1)
            // Return to the begining of the loop if i is less than 10.
            jumpi(loop, lt(i, 10))
        }
    }
}