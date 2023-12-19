const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect, assert } = require("chai");
require('dotenv').config() // 默认是.env文件

describe("Test RouletteGame", function() {
    async function deployTokenFixture() {
        const [owner, addr1, addr2] = await ethers.getSigners();
        
        const RouletteGame = await ethers.getContractFactory("RouletteGame");
        const rouletteGame = await RouletteGame.deploy();
    
        return { RouletteGame, rouletteGame, owner, addr1, addr2 };
    }

    const prizePoolBalance = 100000;
    it(`奖金池的余额必须等于${prizePoolBalance}`, async function() {
        const { rouletteGame } = await loadFixture(deployTokenFixture);
        expect(await rouletteGame.prizePoolBalance()).to.equal(prizePoolBalance);
    });

    const userInitBalance = 100;
    it(`玩家获取初始积分为${userInitBalance}`, async function() {
        const { rouletteGame, addr1 } = await loadFixture(deployTokenFixture);
        await rouletteGame.getInitAmount(addr1);
        const result = await rouletteGame.balanceOf(addr1);
        expect(result).to.equal(userInitBalance);
    });

    it(`下注一次`, async function() {
        const { rouletteGame, addr1} = await loadFixture(deployTokenFixture);
        const betAmount = 100;
        const betNumber = 5;
        const transaction = await rouletteGame.makeBet(addr1, betAmount, betNumber);
        await transaction.wait();
        // const result = await rouletteGame.playersDrawingInfo();
        // console.log(result);
    });
});