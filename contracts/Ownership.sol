// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ownership is Ownable{
    struct RecordData{
        mapping(address => bytes32) accountTolinkHash;
        bytes32 recordHash;
        uint id;
    }

    RecordData[] private recordData;
    constructor(address account) {
        _transferOwnership(account);
    }
    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(bytes32 _recordHash, bytes32 _linkHash, address _sender) public {
        require(_sender == owner(), "Owner check: sender is not the owner");
        RecordData storage newRecord = recordData.push(); 
        newRecord.id = recordData.length;
        newRecord.recordHash = _recordHash;
        newRecord.accountTolinkHash[_sender] = _linkHash;
    }

    function checkRecord(uint index) public view onlyOwner returns(bytes32){
        // console.log("recordHash:");
        console.logBytes32(recordData[index].recordHash);
        return recordData[index].recordHash;
    }
}