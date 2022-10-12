import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("@nomiclabs/hardhat-truffle5");
import * as dotenv from 'dotenv'; // see https://github.com/motdotla/dotenv#how-do-i-use-dotenv-with-import
dotenv.config();

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: "0.8.9",
  networks: {
    goerli: {
      // This value will be replaced on runtime
      url: process.env.STAGING_QUICKNODE_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};

export default config;
