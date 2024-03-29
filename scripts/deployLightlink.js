const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying contracts with the account（my metamask public key）:",
    deployer.address
  );

  const RouletteGame = await ethers.getContractFactory("RouletteGame");
  const rouletteGame = await RouletteGame.deploy();

  console.log("rouletteGame address:", rouletteGame.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
