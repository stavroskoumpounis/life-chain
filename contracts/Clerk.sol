// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./Classifier.sol";

contract ClassifierInterface {
  function registerNode(bytes32 role, address account) public returns(bool){}
  function addRecord(string memory testRecord, uint index) external {}
  function hasRole(bytes32 role, address account) public view returns (bool) {}
}
contract Clerk {
  event Approval(address indexed _sender, address indexed _approved, uint256 indexed _tokenId);
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
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    //recordApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  function registerNodeClassifier(bytes32 role) public onlyUser returns(bool){
    return _registerNodeClassifier(role);
  }
  /**
  * @dev Registers a patient if the account hasn't been registered already
  */
  function _registerNodeClassifier(bytes32 role) private returns(bool){
    return CLC.registerNode(role, msg.sender);
  }

  function addRecordClassifier(string memory testRecord, uint index) public {
    CLC.addRecord(testRecord, index);
  }
}