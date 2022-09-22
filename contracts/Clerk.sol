// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "hardhat/console.sol";
contract Clerk {
  mapping (uint => address) public recordToOwner;
  mapping (uint => address) recordApprovals;
  constructor(){
  }
  modifier onlyOwnerOf(uint _recordId) {
    require(msg.sender == recordToOwner[_recordId]);
    _;
  }

  /**
  * @dev function for transaction approval from user
  */
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    recordApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
}