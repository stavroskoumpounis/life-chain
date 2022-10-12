// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./Classifier.sol";

contract ClassifierInterface {
  function registerNode(bytes32 role, address account) public returns(bool){}
  function _getAccountToOwnership(address account) external view returns(address){}
}
contract OwnershipInterface {
    function addRecord(bytes32 _recordHash, bytes32 _linkHash, address _sender) public {}
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

  function registerNodeClassifier(bytes32 role) public onlyUser returns(bool){
    return _registerNodeClassifier(role);
  }
  /**
  * @dev Registers a patient if the account hasn't been registered already
  */
  function _registerNodeClassifier(bytes32 role) private returns(bool){    
    if (!CLC.registerNode(role, msg.sender)){
      revert AlreadyRegistered({
                account: msg.sender,
                msg: "user already registered"});
    }
    return true;
  }
  /*
    * Patient record adding -- GP adding record TODO
    * require in getAccountToOwnership reverts "account missing role patient"
    */
  function addRecordOwnership(bytes32 recordHash, bytes32 linkHash) public {
    OwnershipInterface OC = OwnershipInterface(CLC._getAccountToOwnership(msg.sender));
    OC.addRecord(recordHash, linkHash , msg.sender);
    emit RecordAdded(msg.sender, recordHash);
  }
}