// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract PandaCoin is ERC20 {
    constructor() ERC20("PandaCoin", "PDC") {
        _mint(msg.sender, 100000000 * 100000000);
    }

    function deposit(uint256 amount) external payable {
        require(amount > 100000000, "deposit amount must larger than 100000000");
        _mint(msg.sender, amount);
    }

    function withdraw(address payable user, uint256 amount) external {
        require(user == msg.sender, "user must be msg.sender");
        require(amount <= balanceOf(msg.sender), "withdraw amount must <= sender's balance");

        _burn(user, amount);
        user.transfer(amount);
    }
}