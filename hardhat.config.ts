import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("@nomiclabs/hardhat-truffle5");

const config: HardhatUserConfig = {
  solidity: "0.8.9",
};

export default config;
