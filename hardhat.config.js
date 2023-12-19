require('dotenv').config() // 默认是.env文件
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",

  networks: {
    hardhat: {},
    // linknet's testnet
    pegasus: {
      url: 'https://replicator.pegasus.lightlink.io/rpc/v1',
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  },
};
