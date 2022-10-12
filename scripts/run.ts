import { ethers } from "hardhat";

async function main() {
    //const clerk = await deployContract('Clerk');
    // const clc = await deployContract('Classifier');
    // const oc = await deployContract('Ownership');

    const clerkContractFactory = await ethers.getContractFactory('Clerk');
    const clerk = await clerkContractFactory.deploy();
    await clerk.deployed();
    console.log("Clerk Contract deployed to:", clerk.address);

    // const [owner, otherAccount] = await ethers.getSigners();
    // const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";

    // const obj = {
    //    table: [] as any
    // };
    // obj.table.push({id: 0, logScore: 15});
    // const testRecord = JSON.stringify(obj);

    // await clerk.connect(otherAccount).registerNodeClassifier(patientRole);
    // await clerk.connect(otherAccount).addRecordOwnership(testRecord);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});