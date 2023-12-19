// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "./Roulette.sol";
import "./JettonPool.sol";

contract RouletteGame is Roulette, JettonPool {

    constructor() {
        owner = msg.sender;
        prizePoolBalance = 100000;
        bettingOdds = 11;
        beginNumber = 1;
        endNumber = 12;
        betCounts = endNumber - beginNumber + 1;
    }

    // 下注
    function makeBet(address payable player, uint256 betAmount, uint8 betNumber) public override {
        uint256 pBlance = playersBlance[player];
        // player is not address 0
        require(player != address(0), "player is not address 0");
        // betAmount is zero
        require(betAmount > 0 && betAmount < pBlance, "betAmount is zero");
        // betNumber is betwenn 0 and 36
        require(betNumber >= 0 && betNumber <= 36, "betNumber is betwenn 0 and 36");

        BetInfo memory betInfo = BetInfo(player, betAmount, betNumber);
        playersBetInfo[player] = betInfo;

        uint256 drawingNumber = beginNumber + random(betCounts - 1);
        uint256 drawingAmount;

        if (betNumber == drawingNumber) { // 中奖
            drawingAmount = betAmount * bettingOdds;
            uint256 diff = drawingAmount - betAmount;
            prizePoolBalance = prizePoolBalance - diff;
            playersBlance[player] = pBlance + diff;
        } else { // 不中奖
            drawingAmount = 0;
            prizePoolBalance = prizePoolBalance + betAmount;
            playersBlance[player] = pBlance - betAmount;
        }

        delete playersBetInfo[player];
    }

    // 玩家获取初始积分
    function getInitAmount(address player) public returns(bool) {
        if (playersHasGetInitAmount[player] > 0) {
            return false;
        } else {
            playersBlance[player] = 100;
            playersHasGetInitAmount[player] = 1;
            return true;
        }
    }

    // 获取玩家的剩余积分
    function balanceOf(address player) public view returns(uint256) {
        return playersBlance[player];
    }

    // 生成随机数
    function random(uint number) public view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao,  
            msg.sender))) % number;
    }

}