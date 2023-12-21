// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PandaCoin is ERC20 {

    address private admin;

    // 货币质押的数量
    uint256 private pledgeAmount = 0;
    // 玩家手中可用的数量
    uint256 private flowAmount = 0;
    // 利润
    uint256 private profitAmount = 0;

    constructor() ERC20("PandaCoin", "PDC") {
        _mint(msg.sender, 100000000 * 100000000);
        admin = msg.sender;
    }

    function deposit() external payable {
        require(msg.value > 100000000, "deposit amount must larger than 100000000");
        // 按照1比1的比例进行兑换
        _mint(msg.sender, msg.value);

        pledgeAmount = pledgeAmount + msg.value;
        flowAmount = flowAmount + msg.value;
    }

    function withdraw(address payable user, uint256 amount) external {
        require(user == msg.sender, "user must be msg.sender");
        require(amount <= balanceOf(msg.sender), "withdraw amount must <= sender's balance");

        _burn(user, amount);
        pledgeAmount = pledgeAmount - amount;
        flowAmount = flowAmount - amount;

        user.transfer(amount);
    }
}