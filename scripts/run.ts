async function main() {
    const lifeContractFactory = await hre.ethers.getContractFactory('Clerk');
    const lifeContract = await lifeContractFactory.deploy();
    await lifeContract.deployed();
    console.log("Contract deployed to:", lifeContract.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});