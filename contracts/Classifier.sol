// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Ownership.sol";
contract Classifier is AccessControl{
    address private clerk;

    struct PublicKey{
        bytes32 pubKeyX;
        bytes1 pubKeyPrefix;
    }

    mapping(address => address) private accountToOwnership;
    mapping(address => PublicKey) private accountToPublicKey;

    modifier onlyClerk() {
        require(msg.sender == clerk);
        _;
    }
    constructor() {
        clerk = msg.sender;
    }
    bytes32 private constant PATIENT = keccak256(abi.encodePacked("PATIENT"));
    bytes32 private constant THERAPIST = keccak256(abi.encodePacked("THERAPIST"));
    
    
    function registerNode(bytes32 role, bytes32 pubKeyX, bytes1 pubKeyPrefix, address account) external onlyClerk returns(bool) {
        require(role == PATIENT || role == THERAPIST, "Role selected can't be registered");
        _grantRole(role, account);
        accountToPublicKey[account].pubKeyX = pubKeyX;
        accountToPublicKey[account].pubKeyPrefix = pubKeyPrefix;
         if(role == PATIENT){
            accountToOwnership[account] = address(new Ownership(account, clerk));
        }
        return true;
    }
    /*
    * gets Ownership Contract mapped to address
    * require limits access to patients only
    */
    function getAccountToOwnership(address account) public view onlyClerk returns(address){
        require(hasRole(PATIENT,account), "Access blocked : account is missing patient role");
        return accountToOwnership[account];
    }

    function getAccountToPublicKey(address account) public view onlyClerk returns(bytes32, bytes1){
        return (accountToPublicKey[account].pubKeyX, accountToPublicKey[account].pubKeyPrefix);
    }


    function hasRole(address account) public view onlyClerk returns (bool) {
        return hasRole(PATIENT, account)|| hasRole(THERAPIST, account);
    }
}