require("@nomicfoundation/hardhat-toolbox");

const fs = require("fs");
let mnemonic = fs.readFileSync(".secret").toString().trim();
let projectId = fs.readFileSync(".infura").toString().trim();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
	  goerli: {
		  url: "https://goerli.infura.io/v3/" + projectId,
		  accounts: {
			  mnemonic,
			  path: "m/44'/60'/0'/0",
			  initialIndex: 0,
			  count: 10
		  }

	  },
	  mainnet: {
		  url: "https://mainnet.infura.io/v3/",
		  accounts: {
			  mnemonic,
			  path: "m/44'/60'/0'/0",
			  initialIndex: 0,
			  count: 10
		  }
	  }
  }
};
