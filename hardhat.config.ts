import { HardhatUserConfig } from "hardhat/config";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-toolbox";
require("@nomiclabs/hardhat-truffle5");
import * as dotenv from 'dotenv'; // see https://github.com/motdotla/dotenv#how-do-i-use-dotenv-with-import
dotenv.config();

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: {
    version: "0.8.16",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    goerli: {
      // This value will be replaced on runtime
      url: process.env.GOERLI_QUICKNODE_KEY,
      accounts: [process.env.PRIVATE_KEY as string],
    },
  },
  gasReporter: {
    enabled: true,
    // outputFile: "gas-report.txt",
    // noColors: true,
    currency: "GBP",
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
  }
};

export default config;
