// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Ownership.sol";
contract OwnershipInterface {
        function addRecord(string memory testRecord) external {}
        function checkRecord(uint index) public view returns(bool){}


}
contract Classifier is AccessControl{
    event RecordAdded(address indexed _sender, bytes32 indexed role, string testRecord);

    mapping(address => address) private accountToOwnership;
    constructor() {
        //_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    // 0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32
    bytes32 private constant PATIENT = keccak256(abi.encodePacked("PATIENT"));
    // 0x4f74ea76300371cf4b3e29c122169252c5f1569c798460a01c5ca3c3efa5ad71
    bytes32 private constant GP = keccak256(abi.encodePacked("GP"));

    function registerNode(bytes32 role, address account) public {
        _grantRole(role, account);
        accountToOwnership[account] = address(new Ownership());
    }

    /*
    * patient record adding -- GP adding record TODO
    * onlyRole reverts "account X missing role y"
    * which also serves a registration check.
    */
    function addRecord(string memory testRecord, uint index) external onlyRole(PATIENT){
        //call ownershipt SC to add
        OwnershipInterface OC = OwnershipInterface(accountToOwnership[msg.sender]);
        OC.addRecord(testRecord);
        console.log("From OC: recordFound:%s", OC.checkRecord(index));
        console.log("From Smart Con: Account: %s and testRecord: %s", msg.sender, testRecord );
        emit RecordAdded(msg.sender, PATIENT, testRecord);
    }
}