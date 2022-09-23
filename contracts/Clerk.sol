// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./Classifier.sol";
contract Clerk {

  Classifier private CLC;
  
  event Approval(address indexed _sender, address indexed _approved, uint256 indexed _tokenId);


  constructor(){
  }
  modifier onlyOwnerOf(uint _recordId) {
    //require(msg.sender == recordToOwner[_recordId]);
    _;
  }

  /**
  * @dev function for transaction approval from user
  */
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    //recordApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  function registerNodeClassifier(bytes32 role) public returns(bool){
    //add modifier
    return _registerNodeClassifier(role);
  }
  /**
  * @dev function for registering a patient and 
  * returning a bool for a succesful match with the intended role
  */
  function _registerNodeClassifier(bytes32 role) internal returns(bool){
    //check if Node already registered ifnot:
    CLC = new Classifier();
    CLC.registerNode(role, msg.sender);
    return CLC.hasRole(role, msg.sender);
  }

}