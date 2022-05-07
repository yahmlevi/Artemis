// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Gas {
    uint public i = 0;

    function simpleSpender() public {
        
        while (true) {
            i += 1;
            if (i == 10000)
                break;
        }
    }

    function callFoo(address _contract) external {
        (bool successful, bytes memory data) = _contract.call
            {value: 420, gas: 5000}
            (abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        
        require(successful, "Call Failed!")
    }
}