// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@pythnetwork/entropy-sdk-solidity/IEntropy.sol";

contract Random {
    // 初始化随机数熵源
    address private entropyAddress = 0x8250f4aF4B972684F7b336503E2D6dFeDeB1487a;
    address private entropyProvider = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;
    IEntropy private entropy = IEntropy(entropyAddress);

    error InsufficientFee();
    error IncorrectSender();

    event FlipRequest(uint64 sequenceNumber);
    event FlipResult(uint64 drawingNumber);

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

        emit FlipResult(uint64(uint256(randomNumber) % 12));
    }

    function getFlipFee() public view returns (uint256 fee) {
        fee = entropy.getFee(entropyProvider);
    }
}