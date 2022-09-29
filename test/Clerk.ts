import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

//const Clerk = hre.artifacts.require("Clerk");

describe("Clerk", function () {

    async function registerPatientFixture() {
        const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
        const Clerk = await ethers.getContractFactory("Clerk");
        const clerk = await Clerk.deploy();
    
        return { clerk, owner, otherAccount, patientRole};
    }
  
    context("With the registration of a patient", async () => {
        it("Should register the patient with the right role", async function () {
            const { patientRole, clerk, otherAccount } = await loadFixture(registerPatientFixture);
            expect(await clerk.connect(otherAccount).callStatic.registerNodeClassifier(patientRole)).to.be.true;
            //await expect(clerk.connect(otherAccount).registerNodeClassifier(patientRole)).to.emit(clerk, "RegistrationSuccess").withArgs(patientRole, otherAccount.address);
        })
        it("Should fail to register if the user has already been registered", async function () {
            const { patientRole, clerk, otherAccount } = await loadFixture(registerPatientFixture);
          
            await clerk.connect(otherAccount).registerNodeClassifier(patientRole)
            expect((await clerk.connect(otherAccount).callStatic.registerNodeClassifier(patientRole))).to.be.false;

        });

    })
    
})