const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect, assert } = require("chai");
require('dotenv').config() // 默认是.env文件

describe("Test TestPandaCoin", function() {

    async function deployTokenFixture() {
        const [owner, addr1, addr2] = await ethers.getSigners();
        
        const PandaCoin = await ethers.getContractFactory("PandaCoin");
        const pandaCoin = await PandaCoin.deploy();
    
        return { PandaCoin, pandaCoin, owner, addr1, addr2 };
    }

    it(`检查初始的总供应`, async function() {
        const { pandaCoin } = await loadFixture(deployTokenFixture);
        const totalSupply = await pandaCoin.totalSupply();
        assert(totalSupply == 100000000 * 100000000, "总供应正确");
    });

    it(`检查充值和提现`, async function() {
        const { pandaCoin, addr1 } = await loadFixture(deployTokenFixture);

        const amount = 100 * 100000000;

        const beforeBalance = await pandaCoin.connect(addr1).balanceOf(addr1);
        await pandaCoin.connect(addr1).deposit({value: amount });
        const depositBalance = await pandaCoin.connect(addr1).balanceOf(addr1);
        await pandaCoin.connect(addr1).withdraw(addr1, amount);
        const withdrawBalance = await pandaCoin.connect(addr1).balanceOf(addr1);
        
        assert(depositBalance - beforeBalance == amount, "充值后余额正确");
        assert(depositBalance - withdrawBalance == amount, "提现后余额正确");
        assert(withdrawBalance - beforeBalance == 0, "前后余额正确");
    });
});