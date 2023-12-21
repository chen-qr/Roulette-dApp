const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect, assert } = require("chai");
require('dotenv').config() // 默认是.env文件

describe("Test TestPandaToken", function() {

    async function deployTokenFixture() {
        const [owner, addr1, addr2] = await ethers.getSigners();
        
        const PandaToken = await ethers.getContractFactory("PandaToken");
        const pandaToken = await PandaToken.deploy();
    
        return { PandaToken, pandaToken, owner, addr1, addr2 };
    }

    it(`检查充值和提现`, async function() {
        const { pandaToken, addr1 } = await loadFixture(deployTokenFixture);

        const amount = 100 * 100000000;

        const beforeBalance = await pandaToken.connect(addr1).getScore(addr1);
        await pandaToken.connect(addr1).deposit({value: amount });
        const depositBalance = await pandaToken.connect(addr1).getScore(addr1);
        await pandaToken.connect(addr1).withdraw(addr1, amount);
        const withdrawBalance = await pandaToken.connect(addr1).getScore(addr1);
        
        assert(depositBalance - beforeBalance == amount, "充值后余额正确");
        assert(depositBalance - withdrawBalance == amount, "提现后余额正确");
        assert(withdrawBalance - beforeBalance == 0, "前后余额正确");
    });
});