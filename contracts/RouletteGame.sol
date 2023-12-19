// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "./Roulette.sol";
import "./JettonPool.sol";

contract RouletteGame is Roulette, JettonPool {

    uint256 public testNum;

    constructor() {
        owner = msg.sender;
        prizePoolBalance = 100000;
    }

    // 下注
    function makeBet(address payable player, uint256 betAmount, uint8 betNumber) public override 
        returns(uint8, uint256) {
        // player is not address 0
        require(player != address(0), "player is not address 0");
        // betAmount is zero
        require(betAmount > 0, "betAmount is zero");
        // betNumber is betwenn 0 and 36
        require(betNumber >= 0 && betNumber <= 36, "betNumber is betwenn 0 and 36");

        BetInfo memory info = BetInfo(player, betAmount, betNumber);
        players[player] = info;

        uint8 drawingNumber = 5;
        uint256 drawingAmount; 
        if (betNumber == drawingNumber) {
            drawingAmount = betAmount * 9;
        } else {
            drawingAmount = 0;
        }
        // return (drawingNumber, drawingAmount);
        testNum = testNum + 1;
        return (5, 5678);
    }
}