// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

// defined interface needed to interact with other contract
interface Ibusinesslogic {
  function getAge() external pure returns(uint);
}

// satelliteV2 uses the Ibusinesslogic interface
contract satelliteV2 is Ibusinesslogic {
  function getAge() override external pure returns(uint) {
    return 32;
  }
}