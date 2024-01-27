const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
	return ethers.utils.parseUnits(n.toString(), 'ether');
}

describe('Miner', () => {
	
	let owner, second
	let mineralCoin, goldCoin, miner
	let result

	beforeEach(async () => {

		[owner, second] = await ethers.getSigners();

		const MineralCoin = await ethers.getContractFactory('MineralCoin');
		mineralCoin = await MineralCoin.deploy();

		const GoldCoin = await ethers.getContractFactory('GoldCoin');
		goldCoin = await GoldCoin.deploy();

		const Miner = await ethers.getContractFactory('Miner');
		miner = await Miner.deploy(mineralCoin.address, goldCoin.address);

		let command = await mineralCoin.connect(owner).approve(miner.address, 1000000);
		await command.wait();

		command = await goldCoin.connect(owner).approve(miner.address, 1000000);
		await command.wait();

	})
	it('First Test', async () => {
		result = await mineralCoin.balanceOf(miner.address);
		expect(result).to.be.equal(0);

		let command = await miner.connect(owner).stake(1000);
		await command.wait();

		result = await miner.walletBalance(owner.address);
		expect(result).to.be.equal(1000);

		result = await mineralCoin.balanceOf(miner.address);
		expect(result).to.be.equal(1000);
	})

	it('Tests the Gold Balances', async () => {
		
		let command = await goldCoin.connect(owner).transfer(second.address, await goldCoin.totalSupply());
		await command.wait();

		result = await goldCoin.balanceOf(second.address);
		expect(result).to.be.equal(await goldCoin.totalSupply());
		expect(result).to.be.equal(BigInt("100000000000000000000000000000000"));
	})
})