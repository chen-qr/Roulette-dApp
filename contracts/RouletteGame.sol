// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "./Roulette.sol";
import "./JettonPool.sol";

contract RouletteGame is Roulette, JettonPool {

    function makeBet(address player, uint256 amount) public override {

    }

    function play(address player) public override {
        
    }
}