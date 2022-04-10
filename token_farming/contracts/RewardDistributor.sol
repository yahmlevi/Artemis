// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './RewardToken.sol';

contract RewardDistributor {

    RewardToken public token;

    mapping(address => uint256) public lastRewardBlock;

    event Mint(
        address to,
        uint amount
    );

    constructor(address _token) {
        token = RewardToken(_token);
    }
    
    function joinList() public {
        require(lastRewardBlock[msg.sender] == 0, 'user already deposited');

        lastRewardBlock[msg.sender] = block.number;
    }

    function withdraw() public {
        require(lastRewardBlock[msg.sender] != 0, 'user didnt deposit');
        require(lastRewardBlock[msg.sender] < block.number, "Wait another block to withdraw");

        // pay 10 tokens per block
        uint256 amount_to_pay = (block.number - lastRewardBlock[msg.sender]) * 10 * 1e18;
        lastRewardBlock[msg.sender] = block.number;

        token.mint(msg.sender, amount_to_pay);
        emit Mint(msg.sender, amount_to_pay);
    }
}