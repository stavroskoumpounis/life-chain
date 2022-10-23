// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//This contract must have access only by patients.
contract Ownership is Ownable{
    struct RecordData{
        mapping(address => bytes32) accountTolinkHash;
        // account => pubKey sign/encrypted hash/id
        bytes32 recordHash;
    }

    // mapping(bytes32 => RecordData) private idToRecord;
    RecordData[] private recordData;
    constructor(address account) {
        _transferOwnership(account);
    }
    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(bytes32 _recordHash, bytes32 _pointer, address _sender) public {
        require(_sender == owner(), "Owner check: sender is not the owner");
        RecordData storage newRecord = recordData.push(); 
        // idToRecord[recordId].accountTolinkHash[_sender] = _pointer;
        // idToRecord[recordId].recordHash = _recordHash;
        newRecord.recordHash = _recordHash;
        newRecord.accountTolinkHash[_sender] = _pointer;
        //owner pointer encrypted by owners pubKey

        //id encrypted with symmetric key and stored -- acts as a pointer
    }

    function checkRecord(uint index) public view onlyOwner returns(bytes32){
        // console.log("recordHash:");
        //validate record hash with incoming hash.
        //console.logBytes32(recordData[index].recordHash);
        //return recordData[index].recordHash;
    }
}