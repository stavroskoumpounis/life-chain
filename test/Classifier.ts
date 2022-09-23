import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Classifier", function () {

    async function registerPatientFixture() {
        const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
    
        const Classifier = await ethers.getContractFactory("Classifier");
        const CLC = await Classifier.deploy();
    
        return { CLC, owner, otherAccount, patientRole };
    }
  
    it("Should register the patient with the right role", async function () {
        const { patientRole, CLC, otherAccount } = await loadFixture(registerPatientFixture);

        await CLC.registerNode(patientRole, otherAccount.address);
        expect(await CLC.hasRole(patientRole, otherAccount.address)).to.be.true;
    });

    xit("Should fail to register if the user has already been registered", async function () {
        // expect().to.equal();
    });

    xit("Should emit the granting of the right role to the right address for the patient", async function () {
  
        // expect().to.equal();
    });

    xit("Should grant the right owner the default admin role", async function () {
        //expect().to.equal();
    });

})