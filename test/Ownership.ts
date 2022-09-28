import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Ownership", function () {
    async function registerPatientFixture() {
        const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
        const Ownership = await ethers.getContractFactory("Ownership");
        const ownshp = await Ownership.deploy();

        var obj = {
            table: [] as any
        };
        obj.table.push({id: 0, logScore: 15});
        var testRecord = JSON.stringify(obj);

        const Classifier = await ethers.getContractFactory("Classifier");
        const CLC = await Classifier.deploy();
    
        return { ownshp, CLC, owner, otherAccount, patientRole, testRecord};
    }
  
    context("With the addition of a record", async () => {
        it("Should register the record with the correct user", async function () {
            const { ownshp, owner, otherAccount, CLC, patientRole, testRecord } = await loadFixture(registerPatientFixture);
            
            //register user
            await CLC.registerNode(patientRole, otherAccount.address);
            await ownshp.connect(owner).addRecord(testRecord);

            expect(await ownshp.connect(owner).checkRecord(0)).to.be.true;
        })
    })
})