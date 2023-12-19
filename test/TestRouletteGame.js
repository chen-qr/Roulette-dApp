const { expect } = require("chai");

describe("Test RouletteGame", function() {
    const prizePoolBalance = 100000;
    it(`奖金池的余额必须等于${prizePoolBalance}`, async function() {
        const [owner] = await ethers.getSigners();

        const RouletteGame = await ethers.getContractFactory("RouletteGame");

        const rouletteGame = await RouletteGame.deploy();
        expect(await rouletteGame.prizePoolBalance()).to.equal(prizePoolBalance);
    });
});