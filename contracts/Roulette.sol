// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;
abstract contract Roulette {

    // 投注信息
    struct BetInfo {
        address player; // 玩家地址
        uint256 betAmount; // 投注金额
        uint8 betNumber; // 压住点数 0～36
    }

    // 玩家的下注信息
    mapping(address => BetInfo) public players;

    // 下注
    function makeBet(address payable player, uint256 betAmount, uint8 betNumber) public virtual;

    // 开奖
    function play(address player) public virtual;

}