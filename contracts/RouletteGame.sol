// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "./Roulette.sol";
import "./JettonPool.sol";
import "@pythnetwork/entropy-sdk-solidity/IEntropy.sol";

contract RouletteGame is Roulette, JettonPool {

    // 初始化随机数熵源
    address private entropyAddress = 0x8250f4aF4B972684F7b336503E2D6dFeDeB1487a;
    address private entropyProvider = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;
    IEntropy private entropy = IEntropy(entropyAddress);

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
        require(betAmount > 0, "betAmount is zero and not less than playamount");
        require(betAmount <= pBlance, "betAmount is less than player's balance");
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

    error InsufficientFee();
    error IncorrectSender();

    event FlipRequest(uint64 sequenceNumber);
    event FlipResult(bool isHeads);

    mapping(uint64 => address) private requestedFlips;

    function requestFlip(bytes32 userCommitment) external payable {
        uint256 fee = entropy.getFee(entropyProvider);
        if (msg.value < fee) {
            revert InsufficientFee();
        }

        uint64 sequenceNumber = entropy.request{value: fee}(
            entropyProvider,
            userCommitment,
            true
        );
        requestedFlips[sequenceNumber] = msg.sender;

        emit FlipRequest(sequenceNumber);
    }

    function revealFlip(
        uint64 sequenceNumber,
        bytes32 userRandom,
        bytes32 providerRandom
    ) public {
        if (requestedFlips[sequenceNumber] != msg.sender) {
            revert IncorrectSender();
        }
        delete requestedFlips[sequenceNumber];

        bytes32 randomNumber = entropy.reveal(
            entropyProvider,
            sequenceNumber,
            userRandom,
            providerRandom
        );

        emit FlipResult(uint256(randomNumber) % 2 == 0);
    }

    function getFlipFee() public view returns (uint256 fee) {
        fee = entropy.getFee(entropyProvider);
    }

}