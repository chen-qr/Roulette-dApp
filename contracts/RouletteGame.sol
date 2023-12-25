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

    event BetRequest(uint64 sequenceNumber);
    event DrawingRequest(uint256 randomNumber, uint256 drawNumber);

    // 投注信息
    struct BetInfo {
        address player; // 玩家地址
        uint256 betAmount; // 投注金额
        uint256 betNumber; // 压住点数 0～36
        bytes32 userCommitment;
        uint64 sequenceNumber;
    }

    constructor() PandaToken() Random(){
        bettingOdds = 11;
        beginNumber = 1;
        endNumber = 12;
        betCounts = endNumber - beginNumber + 1;
    }

    // 下注
    function makeBet(address player, uint256 betAmount, uint256 betNumber, bytes32 userCommitment) external payable {
        require(betAmount > 0 && betAmount <= getScore(), "Bet amount must be greater than 0 and less than user's score!");

        uint64 sequenceNumber = requestFlip(userCommitment);
        playersBetInfo[player] = BetInfo(player, betAmount, betNumber, userCommitment, sequenceNumber);
        emit BetRequest(sequenceNumber);
    }

    function drawing(address player, uint64 sequenceNumber, bytes32 userRandom, bytes32 providerRandom) external {
        require(playersBetInfo[player].sequenceNumber == sequenceNumber, "sequenceNumber is not match");

        uint256 randomNumber = uint256(revealFlip(sequenceNumber, userRandom, providerRandom));
        uint256 drawNumber = (randomNumber % betCounts) + beginNumber;

        emit DrawingRequest(randomNumber, drawNumber);
        uint256 userBetNumber = playersBetInfo[player].betNumber;
        uint256 userBetAmount = playersBetInfo[player].betAmount;
        if (userBetNumber == drawNumber ) { // user win
            compensateScore(player, userBetAmount * bettingOdds - userBetAmount);
        } else {
            takeScore(player, userBetAmount);
        }
        
        delete playersBetInfo[player];
    }


}