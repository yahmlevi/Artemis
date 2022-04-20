// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

Contract AssemblyConditional {

    function regularConditional(uint _v) public returns (uint) {
        if (_v == 5){
            return 55;
        } else if (_v == 6){
            return 66;
        } else {
            return 11;
        }
    }

    // This function is less efficient than the regular conditional.
    function assemblyConditional(uint _v) public returns (uint _r) {
        assembly {
            switch _v
            // If _v is equal to 5, assign 55 to _r.
            case 5 {
                _r := 55
            }
            // If _v is equal to 6, assign 66 to _r.
            case 6 {
                _r := 66
            }
            // If _v is not equal to 5 or 6, assign 11 to _r.
            default {
                _r := 11
            }
        }
    }
}
