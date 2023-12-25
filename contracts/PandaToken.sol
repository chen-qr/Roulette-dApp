// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PandaToken is ERC20 {

    address private admin;

    // 平台积分
    uint256 private platformScore = 0;
    // 货币兑换的积分
    uint256 private pledgeScore = 0;
    // 玩家手中可用的积分
    uint256 private flowScore = 0;
    // 利润
    uint256 private profitScore = 0;
    // 用户积分
    mapping(address => uint256) private userScore;

    constructor() ERC20("PandaCoin", "PDC") {
        admin = msg.sender;
        platformScore = 100000000 * 100000000;
    }

    function deposit() external payable {
        require(msg.value > 100000000, "deposit amount must larger than 100000000");

        userScore[msg.sender] = userScore[msg.sender] + msg.value;
        pledgeScore = pledgeScore + msg.value;
        flowScore = flowScore + msg.value;
        platformScore = platformScore - msg.value;
    }

    function withdraw(address payable user, uint256 amount) external {
        require(user == msg.sender, "user must be msg.sender");
        require(amount <= getScore(), "withdraw amount must <= sender's balance");

        userScore[msg.sender] = userScore[msg.sender] - amount;
        pledgeScore = pledgeScore - amount;
        flowScore = flowScore - amount;
        platformScore = platformScore + amount;
        user.transfer(amount); // 给用户退货币
    }

    function getScore() public view returns(uint256) {
        return userScore[msg.sender];
    }

    function takeScore(address user, uint256 amount) internal {
        require(userScore[user] >= amount, "user's score must >= amount");

        userScore[user] = userScore[user] - amount;
        platformScore = platformScore + amount;
    }

    function compensateScore(address user, uint256 amount) internal {
        require(platformScore >= amount, "platform's score must >= amount");

        userScore[user] = userScore[user] + amount;
        platformScore = platformScore - amount;
    }
}