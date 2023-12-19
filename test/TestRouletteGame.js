const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
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

    // it(`合约的owner是MetaMask的Public Key`, async function() {
    //     const { rouletteGame } = await loadFixture(deployTokenFixture);
    //     expect(await rouletteGame.owner()).to.equal(process.env.PUBLIC_KEY);
    // });

});