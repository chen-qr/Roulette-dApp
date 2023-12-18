// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "./Roulette.sol";
import "./JettonPool.sol";

contract RouletteGame is Roulette, JettonPool {

    function makeBet(address player, uint256 betAmount, uint8 betNumber) public override {
        // player is not address 0
        require(player != address(0), "player is not address 0");
        // betAmount is zero
        require(betAmount > 0, "betAmount is zero");
        // betNumber is betwenn 0 and 36
        require(betNumber >= 0 && betNumber <= 36, "betNumber is betwenn 0 and 36");

        BetInfo memory info = BetInfo(player, betAmount, betNumber);
        players[player] = info;
    }

    function play(address player) public override {
        
    }
}