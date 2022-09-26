// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Classifier is AccessControl{
      constructor() {
        //_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // 0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32
    bytes32 private constant PATIENT = keccak256(abi.encodePacked("PATIENT"));
    // 0x4f74ea76300371cf4b3e29c122169252c5f1569c798460a01c5ca3c3efa5ad71
    bytes32 private constant GP = keccak256(abi.encodePacked("GP"));

    function registerNode(bytes32 role, address account) public {
        _grantRole(role, account);
    }
}