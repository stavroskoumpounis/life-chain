async function main() {
    const lifeContractFactory = await hre.ethers.getContractFactory('Clerk');
    const lifeContract = await lifeContractFactory.deploy();
    await lifeContract.deployed();
    console.log("Contract deployed to:", lifeContract.address);

    const [owner, otherAccount] = await hre.ethers.getSigners();
    const patientRole = "0xe5786ee6f50ab1a5567cb3f3f6840a2f4ddbafdf4a35cb2c52d5b732b1e84a32";
    
    console.log(await lifeContract.connect(otherAccount)._registerNodeClassifier(patientRole));
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});