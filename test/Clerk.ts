import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import web3 from "web3";

//const Clerk = hre.artifacts.require("Clerk");

describe("Clerk", function () {

    async function registerPatientFixture() {
        const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount, account3] = await ethers.getSigners();
        const Clerk = await ethers.getContractFactory("Clerk");
        const clerk = await Clerk.deploy();

        const prov = await ethers.getDefaultProvider();

        const utils = require("./helpers/utils");
        const getPK = require("./helpers/pubkey");

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
    
        return { clerk, owner, otherAccount, patientRole, utils, getPK, testRecord, signHashLink, signHashRecord, prov, account3};
    }
  
    context("With the registration of a patient", async () => {
        it("Should register the patient with the right role", async function () {
            const { patientRole, clerk, owner } = await loadFixture(registerPatientFixture);
            expect(await clerk.connect(owner).callStatic.registerNodeClassifier(patientRole,ethers.utils.id("0x00"),"0x02")).to.be.true;
            //await expect(clerk.connect(otherAccount).registerNodeClassifier(patientRole)).to.emit(clerk, "RegistrationSuccess").withArgs(patientRole, otherAccount.address);
        })
        it("Should fail to register if the user has already been registered", async function () {
            const { patientRole, clerk, otherAccount,utils } = await loadFixture(registerPatientFixture);
          
            const tx = await clerk.connect(otherAccount).registerNodeClassifier(patientRole,ethers.utils.id("0x00"),"0x02");
            const receipt = await tx.wait();

            // console.log(tx);
            // console.log(receipt);

            //expect((await clerk.connect(otherAccount).callStatic.registerNodeClassifier(patientRole))).to.be.false;
            await utils.shouldThrow(clerk.connect(otherAccount).callStatic.hasRoleClassifier(patientRole));
        });

    })

    
    context("With the addition of a record", async () => {
        it("Should add the record with the correct user", async function () {
            const { otherAccount, clerk, patientRole, signHashLink, signHashRecord } = await loadFixture(registerPatientFixture);
            //console.log("From test file: Account: %s and testRecord: %s", otherAccount.address, testRecord);
            //register user

            await clerk.connect(otherAccount).registerNodeClassifier(patientRole, ethers.utils.id("0x00"),"0x02");
            expect (await (clerk.connect(otherAccount).addRecordOwnership(signHashRecord, signHashLink, ethers.utils.id(signHashRecord)))).to.emit(clerk, "RecordAdded").withArgs(otherAccount.address, signHashRecord);
        })
        it("Should fail to create a record if the user hasn't been registered", async function () {
            const { clerk, otherAccount, utils, signHashLink, signHashRecord } = await loadFixture(registerPatientFixture);
            await utils.shouldThrow(clerk.connect(otherAccount).addRecordOwnership(signHashRecord, signHashLink, ethers.utils.id(signHashRecord)));
        });
    })

    context("With retrieving the users public key on the front-end", async () =>{
        it("Should register the correct public key from the metamask wallet", async function () {
            const { owner, clerk, otherAccount, getPK } = await loadFixture(registerPatientFixture);
            
            //const tx = await clerk.connect(owner).registerNodeClassifier(patientRole);
                const patientHash = ethers.utils.id("PATIENT");
				console.log("ethereum object found...executing registerNodeCLC");
				let tx = await clerk.connect(otherAccount).hasRoleClassifier(patientHash);
				//wait for transaction to be mined
                
				const receipt = await tx.wait();
				//console.log(tx);

                //const pubKey = await getPK.getPublicKey(tx);

                const pubKey = "0x045f9ada7a41c1b351e92c9d8b0ab8166896de99054a36a9492857f11a1d97d889980274a2d6f31cedee2b43815f784293b2844cd5286ef0af4775c5417a6fff90";

                const EthCrypto = require('eth-crypto');

                //console.log(pubKey.substring(2,pubKey.length));

                const compresssed = '0x'+EthCrypto.publicKey.compress(pubKey.substring(2,pubKey.length));

                //console.log("comp unhex","0x"+compresssed.substring(2));

                // console.log("back to normal: ", "04"+EthCrypto.publicKey.decompress(compresssed));

                // expect(pubKey).to.equal("0x04"+EthCrypto.publicKey.decompress(compresssed));
                console.log(compresssed);
                console.log(compresssed === "0x025f9ada7a41c1b351e92c9d8b0ab8166896de99054a36a9492857f11a1d97d889")
                // console.log(compresssed);
                // console.log(patientHash);
                const prefix = compresssed.substring(0,4);
                //console.log("this prefix before:",prefix);
                //expect(receipt.status).to.be.equal(1);
				if(receipt.status === 1){
                    let tx2 = await clerk.connect(owner).registerNodeClassifier(patientHash, '0x'+compresssed.substring(4), prefix);
                    
                    let tx3 = await clerk.connect(owner).getPublicKeyClassifier();

                    // console.log("this must be pubkeyX:",tx3[0]);
                    // console.log("this the prefix:",tx3[1]);


                    // console.log(prefix === tx3[1]);
                    // console.log("0x"+compresssed.substring(2) === tx3[0]);

                    const compresssedRetrieved = tx3[1].substring(2)+tx3[0].substring(2);
                    // console.log("compresRetriev",compresssedRetrieved);

                    const decompressed = "0x04"+EthCrypto.publicKey.decompress(compresssedRetrieved);
                    
                    expect(decompressed).to.equal(pubKey);
				 }

            // // var data = await getPK.getPublicKeyAndAddress(tx);

            // console.log("address is:%s", randWallet.address);
            // console.log("public key is: %s \n", randWallet.publicKey);

            // var data2 = await getPK.getPublicKey(tx);

            
        })
    })
})