// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./Classifier.sol";
contract Clerk {

  Classifier private CLC = new Classifier();
  event RegistrationSuccess(bytes32 indexed role, address indexed sender);
  event AlreadyRegistered(bytes32 indexed role, address indexed account, address indexed sender);
  event Approval(address indexed _sender, address indexed _approved, uint256 indexed _tokenId);

  modifier onlyOwnerOf(uint _recordId) {
    //require(msg.sender == recordToOwner[_recordId]);
    _;
  }

  /**
  * @dev transaction approval from user
  * TEMPLATE
  */
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    //recordApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  function registerNodeClassifier(bytes32 role) public {
    //add modifier
    return _registerNodeClassifier(role);
  }
  /**
  * @dev Registers a patient if the account hasn't been registered already
  */
  function _registerNodeClassifier(bytes32 role) internal {
    if (CLC.hasRole(role,msg.sender)){
      emit AlreadyRegistered(role,msg.sender, msg.sender);
    } else{
      CLC.registerNode(role, msg.sender);
      if (CLC.hasRole(role, msg.sender)){
        emit RegistrationSuccess (role, msg.sender);
      }
    }
  }

}