// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//This contract must have access only by patients.
contract Ownership is Ownable{
    struct RecordData{
        mapping(address => bytes) accountToPointer;
        // account => pubKey sign/encrypted hash/id
        bytes32 recordHash;
    }

    mapping(bytes => RecordData) private nameToRecord;
    bytes[] private recordNames;
    constructor(address account) {
        _transferOwnership(account);
    }
    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(bytes32 _hash, bytes memory _pointer, bytes memory _recordName, address _sender) public {
        require(_sender == owner(), "Owner check: sender is not the owner");
        recordNames.push(_recordName);
        // pointer on creating is for real db -- then adding pointers for temp box
        nameToRecord[_recordName].accountToPointer[_sender] = _pointer;
        nameToRecord[_recordName].recordHash = _hash;
    }
    function getRecords(address _sender) public view returns(bytes[] memory){
        require(_sender == owner(), "Owner check: sender is not the owner");
        return recordNames;
    }

    function getPointer(bytes memory recordName, address _sender) public view returns(bytes memory){
        require(_sender == owner(), "Owner check: sender is not the owner");
        return nameToRecord[recordName].accountToPointer[_sender];
    }
    function verifyRecord(bytes memory name, bytes32 expectedHash, address _sender) public view returns(bool){
        require(_sender == owner(), "Owner check: sender is not the owner");
        require(expectedHash == nameToRecord[name].recordHash, "ERROR: record data have changed - hash invalid");
        return true;
    }
}