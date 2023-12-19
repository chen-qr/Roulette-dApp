// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "./Roulette.sol";
import "./JettonPool.sol";

contract RouletteGame is Roulette, JettonPool {

    constructor() {
        owner = msg.sender;
        prizePoolBalance = 100000;
    }

    // 下注
    function makeBet(address payable player, uint256 betAmount, uint8 betNumber) public override {
        // player is not address 0
        require(player != address(0), "player is not address 0");
        // betAmount is zero
        require(betAmount > 0, "betAmount is zero");
        // betNumber is betwenn 0 and 36
        require(betNumber >= 0 && betNumber <= 36, "betNumber is betwenn 0 and 36");

        BetInfo memory betInfo = BetInfo(player, betAmount, betNumber);
        playersBetInfo[player] = betInfo;

        // TODO 还需要根据随机数生成开奖号码
        uint8 drawingNumber = 5;
        uint256 drawingAmount;

        if (betNumber == drawingNumber) { // 中奖
            drawingAmount = betAmount * 9;
            uint256 pBlance = playersBlance[player];
            uint256 diff = drawingAmount - betAmount;
            prizePoolBalance = prizePoolBalance - diff;
            playersBlance[player] = pBlance + diff;
        } else { // 不中奖
            drawingAmount = 0;
            uint256 pBlance = playersBlance[player];
            prizePoolBalance = prizePoolBalance + betAmount;
            playersBlance[player] = pBlance - betAmount;
        }

        delete playersBetInfo[player];
    }

    function getInitAmount(address player) public returns(bool) {
        if (playersHasGetInitAmount[player] > 0) {
            return false;
        } else {
            playersBlance[player] = 100;
            playersHasGetInitAmount[player] = 1;
            return true;
        }
    }

    function balanceOf(address player) public view returns(uint256) {
        return playersBlance[player];
    }
}