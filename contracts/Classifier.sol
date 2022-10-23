// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Ownership.sol";
contract Classifier is AccessControl{
    //event AlreadyRegistered(bytes32 indexed role, address indexed account, address indexed sender, string msg);

    struct PublicKey{
        bytes32 pubKeyX;
        bytes1 pubKeyPrefix;
    }

    mapping(address => address) private accountToOwnership;
    mapping(address => PublicKey) private accountToPublicKey;

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
    bytes32 private constant THERAPIST = keccak256(abi.encodePacked("THERAPIST"));
    //add modifier-fix error
    
    // function registerNode(bytes32 role, address account) public view returns(bool){
    //     if (!hasRole(role,account)){
    //         return true;
    //     }
    //     return false;
    // }
    //could overide grantRole to return true for succesful registration.
    function registerNode(bytes32 role, bytes32 _pubKeyX, bytes1 _pubKeyPrefix, address account) external returns(bool) {
        require(role == PATIENT || role == THERAPIST, "Role selected can't be registered");
        _grantRole(role, account);
        if(role == PATIENT){
            accountToOwnership[account] = address(new Ownership(account));
        }
        accountToPublicKey[account].pubKeyX = _pubKeyX;
        accountToPublicKey[account].pubKeyPrefix = _pubKeyPrefix;
        return true;
    }
    /*
    * gets Ownership Contract mapped to address
    * require limits access to patients only
    */
    function _getAccountToOwnership(address account) public view returns(address){
        require(hasRole(PATIENT,account), "Access blocked : account is missing patient role");
        return accountToOwnership[account];
    }

    // function getAccountToOwnership() public view onlyUser onlyRole(PATIENT) returns(address){
    //     return accountToOwnership[msg.sender];
    // }

    function getAccountToPublicKey(address account) external view returns(bytes32, bytes1){
        return (accountToPublicKey[account].pubKeyX, accountToPublicKey[account].pubKeyPrefix);
    }
}