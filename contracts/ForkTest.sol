// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract ForkTest {

    function getBalance(address v) external view returns(uint256) {
        return address(v).balance;
    }
}