// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ownership is Ownable{
    struct RecordData{
        mapping(address => bool) viewAccess;
        bytes32 queryLink;
        bytes32 recordHash;
        string plainText;
        uint id;
    }

    uint idx;
    RecordData[] private recordData;
    constructor(address account) {
        _transferOwnership(account);
        idx = 0;
    }
    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(string memory testRecord, address _sender) external {
        require(_sender == owner(), "Owner check: sender is not the owner");
        RecordData storage newRecord = recordData.push(); 
        newRecord.viewAccess[msg.sender] = true;
        newRecord.id = idx;
        idx++;
        //temporary simple adding of record -- this should store record data elsewhere
        newRecord.recordHash = keccak256(abi.encodePacked(testRecord));
        newRecord.plainText = testRecord;
    }

    function checkRecord(uint index) public view returns(bool){
        // console.log("recordHash:");
        // console.logBytes32(recordData[index].recordHash);
        console.log("found record: %s",recordData[index].plainText);
        return true;
    }
    
}