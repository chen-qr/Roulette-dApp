// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./PandaToken.sol";
import "./Random.sol";

contract RouletteGame is PandaToken, Random {

    // 下注赔率
    uint256 bettingOdds;
    uint256 beginNumber;
    uint256 endNumber;
    uint256 betCounts;

    // 玩家的下注信息
    mapping(address => BetInfo) public playersBetInfo;

    mapping (address => uint256) public playersHasGetInitAmount;

    // 投注信息
    struct BetInfo {
        address player; // 玩家地址
        uint256 betAmount; // 投注金额
        uint8 betNumber; // 压住点数 0～36
    }

    constructor() PandaToken() Random(){
        bettingOdds = 11;
        beginNumber = 1;
        endNumber = 12;
        betCounts = endNumber - beginNumber + 1;
    }

    // 下注
    function makeBet(address payable player, uint256 betAmount, uint8 betNumber) public {
        
    }


}