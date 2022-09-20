// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "hardhat/console.sol";
contract Clerk {

    string greet;
    constructor(string memory _greet){
        greet = _greet;
        console.log("I AM GROOT!");
    }

    function getGreet() public view returns (string memory) {
        return greet;
    }
}