// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

// defined interface needed to interact with other contract
interface Ibusinesslogic {
  function getAge() external pure returns(uint);
}

// satelliteV1 uses the Ibusinesslogic interface
contract satelliteV1 is Ibusinesslogic {
  function getAge() override external pure returns(uint) {
    return 25;
  }
}