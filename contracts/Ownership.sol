// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//This contract must have access only by patients.
contract Ownership is Ownable{
    struct RecordData{
        mapping(address => bytes32) accountToPointer;
        // account => pubKey sign/encrypted hash/id
        bytes32 recordHash;
    }

    mapping(bytes32 => RecordData) private nameToRecord;
    bytes32[] private recordNames;
    constructor(address account) {
        _transferOwnership(account);
    }
    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(bytes32 _hash, bytes32 _pointer, bytes32 _recordName, address _sender) public {
        require(_sender == owner(), "Owner check: sender is not the owner");
        //RecordData storage newRecord = recordData.push();
        // pointer on creating is for real db -- then adding pointers for temp box
        nameToRecord[_recordName].accountToPointer[_sender] = _pointer;
        nameToRecord[_recordName].recordHash = _hash;
        // newRecord.recordHash = _recordHash;
        // newRecord.accountTolinkHash[_sender] = _pointer;
        //owner pointer encrypted by owners pubKey

        //id encrypted with symmetric key and stored -- acts as a pointer
    }
    function getRecords(address _sender) public view returns(bytes32[] memory){
        require(_sender == owner(), "Owner check: sender is not the owner");
        return recordNames;
    }

    function getPointer(bytes32 recordName, address _sender) public view returns(bytes32){
        require(_sender == owner(), "Owner check: sender is not the owner");
        return nameToRecord[recordName].accountToPointer[_sender];
    }
    function verifyRecord(bytes32 name, bytes32 expectedHash, address _sender) public view returns(bool){
        require(_sender == owner(), "Owner check: sender is not the owner");
        require(expectedHash == nameToRecord[name].recordHash, "ERROR: record data have changed - hash invalid");
        return true;
    }


}