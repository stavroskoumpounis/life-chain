import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Clerk", function () {

    async function registerPatientFixture() {
        const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
    
        const Clerk = await ethers.getContractFactory("Clerk");
        const clerk = await Clerk.deploy();
    
        return { clerk, owner, otherAccount, patientRole };
    }
  
    it("Should register the patient with the right role", async function () {
        const { patientRole, clerk, otherAccount } = await loadFixture(registerPatientFixture);
        const result = await clerk.connect(otherAccount).registerNodeClassifier(patientRole);
        // results return 1 for true 0 for false
        expect(result.v).to.equal(1);
    });

})