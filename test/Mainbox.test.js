const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Mailbox', () => {
    it("should get mailbox contract", async() => {
        const mainboxContract = await ethers.getContractFactory("Mainbox");
    })
    it("should get total letters in the box", async() => {
        const mainboxContract = await ethers.getContractFactory("Mainbox");
        const mailbox = await mainboxContract.deploy();
        expect(await mailbox.totalLetters()).to.equal(0);
    })
    it("should increase by one when get new letter", async() => {
        const mainboxContract = await ethers.getContractFactory("Mainbox");
        const mailbox = await mainboxContract.deploy();
        await mailbox.write("Hello");
        expect(await mailbox.totalLetters()).to.equal(1);
    })
    it("should get mail contents", async () => {
        const mainboxContract = await ethers.getContractFactory("Mainbox");
        const mailbox = await mainboxContract.deploy();
        await mailbox.write("Hello");
        const letter = await mailbox.read()
        expect(letter[0][0]).to.equal("Hello");
    })
    it("should get mail contents", async () => {
        const mainboxContract = await ethers.getContractFactory("Mainbox");
        const mailbox = await mainboxContract.deploy();
        await mailbox.write("Hello");
        const letter = await mailbox.read()
        expect(letter[0][1]).to.equal("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
    })
})