import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { utils } from "../typechain-types/@openzeppelin/contracts";

describe("Classifier", function () {

    async function registerPatientFixture() {
        const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
        const utils = require("./helpers/utils");
        var obj = {
            table: [] as any
        };
        obj.table.push({id: 1, logScore: 15});
        var testRecord = JSON.stringify(obj);

        const Classifier = await ethers.getContractFactory("Classifier");
        const CLC = await Classifier.deploy();
    
        return { CLC, owner, otherAccount, patientRole, utils, testRecord };
    }
    context("With the registration of a patient", async () => {
        it("Should register the patient with the right role", async function () {
            const { patientRole, CLC, otherAccount } = await loadFixture(registerPatientFixture);

            await CLC.registerNode(patientRole, otherAccount.address);
            expect(await CLC.hasRole(patientRole, otherAccount.address)).to.be.true;
        });

        it("Should fail to register if the user has already been registered", async function () {
            const { patientRole, CLC, otherAccount } = await loadFixture(registerPatientFixture);

            await CLC.registerNode(patientRole, otherAccount.address);
            expect(await CLC.registerNode(patientRole, otherAccount.address)).to.emit(CLC, "AlreadyRegistered");
        });

        xit("Should grant the right owner the default admin role", async function () {
            //expect().to.equal();
        });
    })


    context("With the addition of a record", async () => {
        it("Should register the record with the correct user", async function () {
            const {owner, otherAccount, CLC, patientRole, testRecord } = await loadFixture(registerPatientFixture);
            console.log("From test file: Account: %s and testRecord: %s", otherAccount.address, testRecord);
            //register user
            await CLC.registerNode(patientRole, owner.address);
            await expect ((CLC.connect(owner).addRecord(testRecord, 0))).to.emit(CLC, "RecordAdded").withArgs(owner.address, patientRole, testRecord);
        })
        it("Should fail to create a record if the user hasn't been registered", async function () {
            const { CLC, otherAccount, patientRole, utils, testRecord } = await loadFixture(registerPatientFixture);
            await utils.shouldThrow(CLC.connect(otherAccount).addRecord(testRecord, 0));
        });
    })

})