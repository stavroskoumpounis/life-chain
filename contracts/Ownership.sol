// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;
import "@openzeppelin/contracts/access/Ownable.sol";

//This contract must have access only by patients.
contract Ownership is Ownable{
    event RecordAdded(address indexed _sender, bytes32 indexed recordHash);
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
        require(buildingContract != address(0));
        clerk = buildingContract;
        _transferOwnership(patient);
    }

    /*
    * Only the owner of the OC can add a record
    */
    function addRecord(bytes32 hash, bytes memory pointer, bytes memory recordName, address sender) public onlyClerk {
        require(sender == owner(), "Owner check: sender is not the owner");
        recordNames.push(recordName);
        // pointer on creating is for real db -- then adding pointers for temp box
        nameToRecord[recordName].accountToPointer[sender] = pointer;
        nameToRecord[recordName].recordHash = hash;
        emit RecordAdded(msg.sender, hash);
    }
    function addSharedPointer (address sender, address clinician, bytes memory recordName, bytes memory pointer) public onlyClerk {
        require(sender == owner(), "Owner check: sender is not the owner");
        nameToRecord[recordName].accountToPointer[clinician] = pointer;
    }
    function getRecords(address sender) public view onlyClerk returns(bytes[] memory) {
        require(sender == owner(), "Owner check: sender is not the owner");
        return recordNames;
    }
    function getPointer(bytes memory recordName, address sender) public view onlyClerk returns(bytes memory){
        require(sender == owner(), "Owner check: sender is not the owner");
        return nameToRecord[recordName].accountToPointer[sender];
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