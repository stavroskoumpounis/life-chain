// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//This contract must have access only by patients.
contract Ownership is Ownable{
    struct RecordData{
        mapping(address => bytes) accountToPointer;
        // account => pubKey sign/encrypted hash/id
        bytes32 recordHash;
    }

    //add only calls from a specific contract
    address private clerk;

    //calls limited to clerk & classifier to tighten security
    modifier onlyClerk() {
        require(msg.sender == clerk);
        _;
    }

    mapping(bytes => RecordData) private nameToRecord;
    bytes[] private recordNames;

    constructor(address patient, address buildingContract) {
        clerk = buildingContract;
        _transferOwnership(patient);
    }

    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(bytes32 _hash, bytes memory _pointer, bytes memory _recordName, address _sender) public onlyClerk {
        require(_sender == owner(), "Owner check: sender is not the owner");
        recordNames.push(_recordName);
        // pointer on creating is for real db -- then adding pointers for temp box
        nameToRecord[_recordName].accountToPointer[_sender] = _pointer;
        nameToRecord[_recordName].recordHash = _hash;
    }
    function addSharedPointer (address _sender, address clinician, bytes memory _recordName, bytes memory pointer) public onlyClerk {
        require(_sender == owner(), "Owner check: sender is not the owner");
        nameToRecord[_recordName].accountToPointer[clinician] = pointer;
    }
    function getRecords(address _sender) public view onlyClerk returns(bytes[] memory) {
        require(_sender == owner(), "Owner check: sender is not the owner");
        return recordNames;
    }
    function getPointer(bytes memory recordName, address _sender) public view onlyClerk returns(bytes memory){
        require(_sender == owner(), "Owner check: sender is not the owner");
        return nameToRecord[recordName].accountToPointer[_sender];
    }
    function getSharedPointer(bytes memory recordName, address patient, address sender) public onlyClerk view returns(bytes memory){
        require(patient == owner(), "Owner check: patient is not the owner");
        require(nameToRecord[recordName].accountToPointer[sender].length != 0, "error: no shared pointer present");
        return nameToRecord[recordName].accountToPointer[sender];
    }
    function verifyRecord(bytes memory name, bytes32 expectedHash) public view onlyClerk returns(bool){
        require(expectedHash == nameToRecord[name].recordHash, "ERROR: record data have changed - hash invalid");
        return true;
    }
}