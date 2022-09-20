import { artifacts, assert, web3 } from "hardhat";

const Clerk = artifacts.require("Clerk");

describe("Clerk contract", function() {
    let accounts;

    before(async function () {
        accounts = await web3.eth.getAccounts();
    })

    describe("Deployment", function () {
        it("Should deploy with the right message", async function () {
            const clerk = await Clerk.new("I AM GROOT?");
            assert.equal(await clerk.getGreet(), "I AM GROOT?");
        })
    })
})