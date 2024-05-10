require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",

  networks: {
    hardhat: {
      // fork主网
      forking: {
        url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`
      }
    },
    // linknet's testnet
    pegasus: {
      url: 'https://replicator.pegasus.lightlink.io/rpc/v1',
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  },
};
