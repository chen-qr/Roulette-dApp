// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

abstract contract JettonPool {

    address public owner;
    uint256 public prizePoolBalance;
    mapping(address => uint256) public playersBlance;
}