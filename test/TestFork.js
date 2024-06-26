const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect, assert } = require("chai");

describe("Test Fork", function() {

    async function deployTokenFixture() {
        const ForkTest = await ethers.getContractFactory("ForkTest");
        const forkTest = await ForkTest.deploy();
    
        return { ForkTest, forkTest};
    }

    it(`检查是否Fork主网`, async function() {
        const { forkTest } = await loadFixture(deployTokenFixture);

        const balance = await forkTest.getBalance(process.env.FORK_TEST_ADDR);
        assert(balance > 0.0001 * 10^18,  "测试账户在主网超过0.0001ETH，Fork主网成功");
    });
});