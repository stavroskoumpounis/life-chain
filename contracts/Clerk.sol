// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import "./Classifier.sol";

contract Clerk {
  error AlreadyRegistered(address account, string msg);

  bool private stopped = false;
  address private admin;

  Classifier private clc;

  function toggleCircuitBreaker() public {
    require(msg.sender == admin);
    stopped = !stopped;
  }
  
  modifier stopInEmergency { require(!stopped, "contract has been stopped via circuit breaker"); _; }

  /// @dev Check if method was called by a connected user with a wallet and not other contracts.
  //add only registered user
  modifier onlyUser() {
    require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
    _;
  }

  modifier onlyRegistered(){
    require(clc.hasRole(msg.sender), "Access blocked: user isn't registered");
    _;
  }
  constructor(){
    admin = msg.sender;
    clc = Classifier(address(new Classifier()));
  }

  fallback() external payable {revert();}
  receive() external payable {revert();}
  function withdrawEth() public{
    require(msg.sender == admin);
    address payable to = payable(msg.sender);
    to.transfer(address(this).balance);
  }
  
  function getPublicKeyClassifier() public view onlyUser stopInEmergency returns(bytes32, bytes1){
    return (clc.getAccountToPublicKey(msg.sender));
  }
  function hasRoleClassifier(bytes32 role) public view onlyUser stopInEmergency returns(bool) {
    if (clc.hasRole(role, msg.sender)){
      return true;
    }
    return false;
  }
  /**
  * @dev Registers a patient if the account hasn't been registered already
  */
  function registerNodeClassifier(bytes32 role, bytes32 pubKeyX, bytes1 pubKeyPrefix) public onlyUser stopInEmergency returns(bool){    
    if (clc.hasRole(role, msg.sender)){
      revert AlreadyRegistered({
        account: msg.sender,
        msg: "user already registered"});
    } else {
      return clc.registerNode(role, pubKeyX, pubKeyPrefix, msg.sender);
    }
  }
  /**
  * Patient record adding
  * @dev getAccountToOwnership reverts if caller!=patient, limits record addition to patients only.
  * 
  *  gas/sec optimisation -- seperate add record function in case of reversion
  */
  function addRecordOwnership(bytes32 hash, bytes calldata pointer, bytes calldata recordName) public stopInEmergency {
    Ownership OC = Ownership(clc.getAccountToOwnership(msg.sender));
    OC.addRecord(hash, pointer, recordName, msg.sender);
  }
  function getPointerOwnership(bytes calldata recordName) public view stopInEmergency returns(bytes memory){
    Ownership OC = Ownership(clc.getAccountToOwnership(msg.sender));
    return OC.getPointer(recordName, msg.sender);
  }
  function verifyRecordOwnership(bytes calldata name, bytes32 expectedHash, address patient) public view onlyRegistered stopInEmergency returns(bool){
    Ownership OC = Ownership(clc.getAccountToOwnership(patient));
    return OC.verifyRecord(name, expectedHash);
  }
  function getRecordsOwnership() public view stopInEmergency returns(bytes[] memory){
    Ownership OC = Ownership(clc.getAccountToOwnership(msg.sender));
    return OC.getRecords(msg.sender);
  }
   function getSharedPointerOwnership(bytes calldata recordName, address patient) public view onlyRegistered stopInEmergency returns(bytes memory){
    Ownership OC = Ownership(clc.getAccountToOwnership(patient));
    return OC.getSharedPointer(recordName, patient, msg.sender);
   }
}