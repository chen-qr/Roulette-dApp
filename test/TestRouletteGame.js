const { expect } = require("chai");

describe("Test RouletteGame", function() {
    it("奖金池的余额必须大于0", async function() {
        const [owner] = await ethers.getSigners();

        const RouletteGame = await ethers.getContractFactory("RouletteGame");

        const rouletteGame = await RouletteGame.deploy();
        expect(await rouletteGame.prizePoolBalance()).to.not.equal(0);
    });
});