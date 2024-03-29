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
    mapping(address => BetInfo) private playersBetInfo;

    event BetRequest(uint64 sequenceNumber);

    event DrawingRequest(
        uint256 previousBlockId,
        uint256 drawNo,
        uint256 drawTime,
        address player, 
        uint64 sequenceNumber, 
        bytes32 userRandom, 
        bytes32 providerRandom, 
        uint256 finnalRandom, 
        uint256 drawNumber, 
        uint256 betAmount,
        uint256 betNumber,
        bool isWin
    );

    mapping(address => uint256) private playerRecordLatestBlockId;
    mapping(address => uint256) private playerDrawCnts;

    // 投注信息
    struct BetInfo {
        address player; // 玩家地址
        uint256 betAmount; // 投注金额
        uint256 betNumber; // 压住点数 1～36
        uint64 sequenceNumber;
    }

    constructor() PandaToken() Random(){
        beginNumber = 1;
        endNumber = 36;
        bettingOdds = 30; // 赔率调低一点
        betCounts = endNumber - beginNumber + 1;
    }

    // 下注
    function makeBet(address player, uint256 betAmount, uint256 betNumber, bytes32 userCommitment) external payable {
        require(betAmount > 0 && betAmount <= getScore(), "Bet amount must be greater than 0 and less than user's score!");
        // TODO 限制最小和最大的下注金额。如果不限制金额，会存在安全问题。

        uint64 sequenceNumber = requestFlip(userCommitment);
        playersBetInfo[player] = BetInfo(player, betAmount, betNumber, sequenceNumber);
        emit BetRequest(sequenceNumber);
    }

    function drawing(address player, uint64 sequenceNumber, bytes32 userRandom, bytes32 providerRandom) external {
        require(playersBetInfo[player].sequenceNumber == sequenceNumber, "sequenceNumber is not match");

        uint256 finnalRandom = uint256(revealFlip(sequenceNumber, userRandom, providerRandom));
        uint256 drawNumber = (finnalRandom % betCounts) + beginNumber;
        uint256 drawNo = playerDrawCnts[msg.sender] + 1;
        uint256 previousBlockId = playerRecordLatestBlockId[msg.sender];

        uint256 betNumber = playersBetInfo[player].betNumber;
        uint256 betAmount = playersBetInfo[player].betAmount;
        
        bool isWin = betNumber == drawNumber;
        if (isWin) { // user win
            compensateScore(player, betAmount * bettingOdds - betAmount);
        } else {
            takeScore(player, betAmount);
        }

        // log draw event        
        emit DrawingRequest(previousBlockId, drawNo, block.timestamp, msg.sender, sequenceNumber, userRandom, providerRandom, finnalRandom, drawNumber, betAmount, betNumber, isWin); 

        playerRecordLatestBlockId[msg.sender] = block.number;
        playerDrawCnts[msg.sender] = drawNo;

        delete playersBetInfo[player];
    }

    function getBetInfo() external view returns(uint256 betAmount, uint256 betNumber, uint64 sequenceNumber) {
        BetInfo memory betInfo = playersBetInfo[msg.sender];
        betAmount = betInfo.betAmount;
        betNumber = betInfo.betNumber;
        sequenceNumber = betInfo.sequenceNumber;
    }

    function getRecordLatestBlockId() external view returns(uint256) {
        return playerRecordLatestBlockId[msg.sender];
    }

    function getDrawCnt() external view returns(uint256) {
        return playerDrawCnts[msg.sender];
    }
}