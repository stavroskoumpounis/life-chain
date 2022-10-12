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

        const utils = require("./helpers/utils");
        var obj = {
            table: [] as any
        };
        obj.table.push({id: 0, logScore: 15});
        var testRecord = JSON.stringify(obj);

        // applying sign-then-encrypt
        let signedRecord = (await otherAccount.signMessage(testRecord)).toString();
        // console.log("\nthis is the signedRecord: %s",signedRecord);
        let signHashRecord = ethers.utils.hashMessage(signedRecord);
        // console.log("this is the singedhashedRecord: %s",signHashRecord);

        let signedLink = (await otherAccount.signMessage("https://this.is.a.query.link")).toString();
        // console.log("this is the signedQuery: %s",signedLink);
        let signHashLink = ethers.utils.hashMessage(signedLink);
        // console.log("this is the signHashQuery: %s",signHashLink);
    
        return { clerk, owner, otherAccount, patientRole, utils, testRecord, signHashLink, signHashRecord
        };
    }
  
    context("With the registration of a patient", async () => {
        it("Should register the patient with the right role", async function () {
            const { patientRole, clerk, owner } = await loadFixture(registerPatientFixture);
            expect(await clerk.connect(owner).callStatic.registerNodeClassifier(patientRole)).to.be.true;
            //await expect(clerk.connect(otherAccount).registerNodeClassifier(patientRole)).to.emit(clerk, "RegistrationSuccess").withArgs(patientRole, otherAccount.address);
        })
        it("Should fail to register if the user has already been registered", async function () {
            const { patientRole, clerk, otherAccount,utils } = await loadFixture(registerPatientFixture);
          
            await clerk.connect(otherAccount).registerNodeClassifier(patientRole)
            //expect((await clerk.connect(otherAccount).callStatic.registerNodeClassifier(patientRole))).to.be.false;
            await utils.shouldThrow(clerk.connect(otherAccount).callStatic.registerNodeClassifier(patientRole));
        });

    })

    
    context("With the addition of a record", async () => {
        it("Should add the record with the correct user", async function () {
            const { otherAccount, clerk, patientRole, signHashLink, signHashRecord } = await loadFixture(registerPatientFixture);
            //console.log("From test file: Account: %s and testRecord: %s", otherAccount.address, testRecord);
            //register user

            await clerk.connect(otherAccount).registerNodeClassifier(patientRole);
            expect (await (clerk.connect(otherAccount).addRecordOwnership(signHashRecord, signHashLink))).to.emit(clerk, "RecordAdded").withArgs(otherAccount.address, signHashRecord);
        })
        it("Should fail to create a record if the user hasn't been registered", async function () {
            const { clerk, otherAccount, utils, signHashLink, signHashRecord } = await loadFixture(registerPatientFixture);
            await utils.shouldThrow(clerk.connect(otherAccount).addRecordOwnership(signHashRecord, signHashLink));
        });
    })
    
})