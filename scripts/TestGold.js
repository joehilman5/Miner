const hre = require('hardhat');

require('dotenv').config();

async function main() {

	let result;

	const [owner, second] = await ethers.getSigners();

	const secondAccount = process.env.TEST.toString();

	const GoldCoin = await ethers.getContractFactory('GoldCoin');
	const goldCoin = await GoldCoin.deploy();
	await goldCoin.deployed();
	console.log(`Deployed Gold Coin Contract at: ${goldCoin.address}`);

	const command = await goldCoin.connect(owner).transfer(secondAccount, BigInt("50000000000000000000000000000000"));
	await command.wait();

	result = await goldCoin.balanceOf(owner.address);
	console.log(`Balance of Owner Account: ${result}`);

	result = await goldCoin.balanceOf(second.address);
	console.log(`Balance of Second Account: ${result}`);

	console.log(`Second Address is: ${secondAccount}`);
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});