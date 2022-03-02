// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './TokenArtemis.sol';

contract BridgeRopsten {
  address public admin;
  TokenArtemis public token;
  mapping(address => mapping(uint => bool)) public processedNonces;

  enum Step { Burn, Mint }
  event Transfer(
    address from,
    address to,
    uint amount,
    uint date,
    uint nonce,
    Step indexed step
  );

  constructor(address _token) {
    admin = msg.sender;
    token = TokenArtemis(_token);
  }

  function burn(address to, uint amount, uint nonce) external {
    require(processedNonces[msg.sender][nonce] == false, 'transfer already processed');
    processedNonces[msg.sender][nonce] = true;
    token.burn(msg.sender, amount);
    emit Transfer(
      msg.sender,
      to,
      amount,
      block.timestamp,
      nonce,
      Step.Burn
    );
  }

  function mint(address from, address to, uint amount, uint nonce) external {
    // TODO
    // should be required that ONLY the off-chain component can mint, i.e. the admin address
    // require(is off-chain component, 'only off-chain component can mint');
    require(processedNonces[from][nonce] == false, 'transfer already processed');
    processedNonces[from][nonce] = true;
    token.mint(to, amount);
  }

}