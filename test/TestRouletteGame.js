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

    it(`下注一次`, async function() {
        const { rouletteGame, addr1} = await loadFixture(deployTokenFixture);
        const betAmount = 100;
        const betNumber = 5;
        // const {drawingNumber, drawingAmount} = await rouletteGame.makeBet(addr1, betAmount, betNumber);
        // console.log(drawingNumber, drawingAmount);
        const transaction = await rouletteGame.makeBet(addr1, betAmount, betNumber);
        await transaction.wait();
        // const result = await rouletteGame.test();
        console.log(transaction);
        // if (drawingNumber == betNumber) {
        //     assert(drawingAmount == betAmount * 9, "中奖后，返回金额等于下注的倍数");
        // } else {
        //     assert(drawingAmount == 0, "没中奖，返回金额为0");
        // }
    });
});