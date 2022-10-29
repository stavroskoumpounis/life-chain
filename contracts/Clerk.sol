// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./Classifier.sol";

contract ClassifierInterface {
  function registerNode(bytes32 role, bytes32 _pubKeyX, bytes1 _pubKeyPrefix, address account) external returns(bool){}
  function hasRole(bytes32 role, address account) public view returns(bool){}
  function _getAccountToOwnership(address account) external view returns(address){}
  function getAccountToPublicKey(address account) external view returns(bytes32, bytes1){}
}
contract OwnershipInterface {
    function addRecord(bytes32 _hash, bytes calldata _pointer, bytes calldata _recordName, address _sender) public {}
    function getPointer(bytes calldata recordName, address _sender) public view returns(bytes memory){}
    function getRecords(address _sender) public view returns(bytes32[] memory){}
    function verifyRecord(bytes calldata name, bytes32 expectedHash, address _sender) public view returns(bool){}

}
contract Clerk {
  event Approval(address indexed _sender, address indexed _approved, uint256 indexed _tokenId);
  event RecordAdded(address indexed _sender, bytes32 indexed recordHash);
  error AlreadyRegistered(address account, string msg);

  ClassifierInterface private CLC;
  /// @dev Check if method was called by a connected user with a wallet and not other contracts.
  modifier onlyUser() {
    require(msg.sender == tx.origin, "Reverting, Method can only be called directly by user.");
    _;
  }
  modifier onlyOwnerOf(uint256 _tokenId){
    _;
  }
  constructor(){
    CLC = ClassifierInterface(address(new Classifier()));
  }
  /**
  * @dev transaction approval from user
  * TEMPLATE
  */
  function approve(address _approved, uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
    //recordApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  function getPublicKeyClassifier() public view onlyUser returns(bytes32, bytes1){
    return (CLC.getAccountToPublicKey(msg.sender));
  }

  function hasRoleClassifier(bytes32 role) public view onlyUser returns(bool) {
    if (CLC.hasRole(role, msg.sender)){
      revert AlreadyRegistered({
        account: msg.sender,
        msg: "user already registered"});
    }
    return false;
  }
  /**
  * @dev Registers a patient if the account hasn't been registered already
  */
  function registerNodeClassifier(bytes32 role, bytes32 pubKeyX, bytes1 pubKeyPrefix) public onlyUser returns(bool){    
    if (CLC.hasRole(role, msg.sender)){
      revert AlreadyRegistered({
        account: msg.sender,
        msg: "user already registered"});
    } else {
      return CLC.registerNode(role, pubKeyX, pubKeyPrefix, msg.sender);
    }
  }
  /**
  * Patient record adding
  * @dev getAccountToOwnership reverts if caller!=patient, limits record addition to patients only.
  * 
  *  gas/sec optimisation -- seperate add record function in case of reversion
  */
  function addRecordOwnership(bytes32 hash, bytes calldata pointer, bytes calldata recordName) public {
    OwnershipInterface OC = OwnershipInterface(CLC._getAccountToOwnership(msg.sender));
    OC.addRecord(hash, pointer, recordName, msg.sender);
    emit RecordAdded(msg.sender, hash);
  }

  function getPointerOwnership(bytes calldata recordName) public view returns(bytes memory){
    OwnershipInterface OC = OwnershipInterface(CLC._getAccountToOwnership(msg.sender));
    return OC.getPointer(recordName, msg.sender);
  }

  function verifyRecordOwnership(bytes calldata name, bytes32 expectedHash) public view returns(bool){
    OwnershipInterface OC = OwnershipInterface(CLC._getAccountToOwnership(msg.sender));
    return OC.verifyRecord(name, expectedHash, msg.sender);
  }

  function getRecordsOwnership() public view returns(bytes32[] memory){
    OwnershipInterface OC = OwnershipInterface(CLC._getAccountToOwnership(msg.sender));
    return OC.getRecords(msg.sender);
  }

}