const hre = require('hardhat');

async function main() {

	const [owner, second] = await ethers.getSigners();

	const MineralCoin = await ethers.getContractFactory('MineralCoin');
	const mineralCoin = await MineralCoin.deploy();
	await mineralCoin.deployed();
	console.log(`Deployed Mineral Coin Contract at: ${mineralCoin.address}`);

	const GoldCoin = await ethers.getContractFactory('GoldCoin');
	const goldCoin = await GoldCoin.deploy();
	await goldCoin.deployed();
	console.log(`Deployed Gold Coin Contract at: ${goldCoin.address}`);

	const Miner = await ethers.getContractFactory('Miner');
	const miner = await Miner.deploy(mineralCoin.address, goldCoin.address);
	await miner.deployed();
	console.log(`Deployed Miner Contract at: ${miner.address}`);


}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});