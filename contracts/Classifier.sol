// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Ownership.sol";
contract Classifier is AccessControl{
    event AlreadyRegistered(bytes32 indexed role, address indexed account, address indexed sender);

    mapping(address => address) private accountToOwnership;

    /// @dev Check if method was called by a connected user with a wallet and not other contracts.
    modifier onlyUser() {
        require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
        _;
    }
    constructor() {
        //_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    // 0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32
    bytes32 private constant PATIENT = keccak256(abi.encodePacked("PATIENT"));
    // 0x4f74ea76300371cf4b3e29c122169252c5f1569c798460a01c5ca3c3efa5ad71
    bytes32 private constant GP = keccak256(abi.encodePacked("GP"));
    //add modifier-fix error
    function registerNode(bytes32 role, address account) public returns(bool){
        return _registerNode(role, account);
    }
    //could overide grantRole to return true for succesful registration.
    function _registerNode(bytes32 role, address account) internal returns(bool){
        if (!hasRole(role,account)){
            _grantRole(role, account);
            accountToOwnership[account] = address(new Ownership(account));
            return true;
        } else{
            emit AlreadyRegistered(role,msg.sender, msg.sender);
            return false;
        }

    }
    /*
    * gets Ownership Contract mapped to address
    */
    function getAccountToOwnership(address account) external view returns(address){
        require(hasRole(PATIENT,account), "failed require: account is missing patient role");
        return accountToOwnership[account];
    }
}