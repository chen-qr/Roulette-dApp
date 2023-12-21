const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect, assert } = require("chai");
require('dotenv').config() // 默认是.env文件

// describe("Test RouletteGame", function() {
//     async function deployTokenFixture() {
//         const [owner, addr1, addr2] = await ethers.getSigners();
        
//         const RouletteGame = await ethers.getContractFactory("RouletteGame");
//         const rouletteGame = await RouletteGame.deploy();
    
//         return { RouletteGame, rouletteGame, owner, addr1, addr2 };
//     }

//     const prizePoolBalance = 100000;
//     it(`奖金池的余额必须等于${prizePoolBalance}`, async function() {
//         const { rouletteGame } = await loadFixture(deployTokenFixture);
//         expect(await rouletteGame.prizePoolBalance()).to.equal(prizePoolBalance);
//     });

//     const userInitBalance = 100;
//     it(`玩家获取初始积分为${userInitBalance}`, async function() {
//         const { rouletteGame, addr1 } = await loadFixture(deployTokenFixture);
//         await rouletteGame.getInitAmount(addr1);
//         await rouletteGame.getInitAmount(addr1); // 故意执行多次
//         await rouletteGame.getInitAmount(addr1);
//         expect(await rouletteGame.balanceOf(addr1)).to.equal(userInitBalance);
//     });

//     it(`下注后玩家奖金和剩余奖金的关系正常`, async function() {
//         const { rouletteGame, addr1} = await loadFixture(deployTokenFixture);
//         await rouletteGame.getInitAmount(addr1);
//         const betAmount = 10;
//         const betNumber = 5;
//         const beforePrizePoolBalance = await rouletteGame.prizePoolBalance();
//         const beforePlayBalance = await rouletteGame.balanceOf(addr1);
//         await rouletteGame.makeBet(addr1, betAmount, betNumber);
//         const afterPrizePoolBalance = await rouletteGame.prizePoolBalance();
//         const afterPlayBalance = await rouletteGame.balanceOf(addr1);
//         assert(beforePrizePoolBalance != afterPrizePoolBalance, "下注钱后奖金池不能相等");
//         if (afterPrizePoolBalance > beforePrizePoolBalance) { // 玩家输
//             assert(afterPrizePoolBalance - beforePrizePoolBalance == betAmount, "奖金池增加的积分等于玩家下注");
//             assert(beforePlayBalance - afterPlayBalance, "玩家减少的积分等于玩家下");
//         } else { // 玩家赢
//             const diff = betAmount * 11 - betAmount; // 玩家获利数据
//             assert(beforePrizePoolBalance - afterPrizePoolBalance == diff, "奖金池减少的积分等于玩家获利");
//             assert(afterPlayBalance - beforePlayBalance == diff, "玩家增加的积分等于玩家获利");
//         }
//     });

//     it(`玩家只要不断下注，账户就会输光`, async function() {
//         const { rouletteGame, addr1} = await loadFixture(deployTokenFixture);
//         await rouletteGame.getInitAmount(addr1);
//         let pBalance = await rouletteGame.balanceOf(addr1);
//         let betTimes = 0;
//         while (pBalance > 0) {
//             const betAmount = 10;
//             const betNumber = 5;
//             await rouletteGame.makeBet(addr1, betAmount, betNumber);
//             betTimes = betTimes + 1;
//             pBalance = await rouletteGame.balanceOf(addr1);
//         }
//     });
// });