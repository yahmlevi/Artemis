// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

// defined interface needed to interact with other contract
interface Ibusinesslogic {
  function getAge() external pure returns(uint);
}

contract MainContract {
  
  address public admin;
  Ibusinesslogic public businesslogic;
  
  constructor() {
    admin = msg.sender;
  }

 
  // upgrade business logic (point to new contract)
  function upgrade(address _businesslogic) external {
    require(msg.sender == admin, 'only admin');
    businesslogic = Ibusinesslogic(_businesslogic);
  }


  // call the getAge function using the businesslogic function
  function getAge() external view returns(uint) {
    return businesslogic.getAge();
  }
}