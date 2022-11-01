const path = require("path");
require("dotenv").config({path: '../.env'})
const MNEMONIC = process.env["MNEMONIC"];
const HDWalletProvider = require("@truffle/hdwallet-provider");
const AccountIndex = 0;

module.exports = {

  contracts_build_directory: "../client/src/contracts",
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    bsc_testnet: {
      provider: function(){
        return new HDWalletProvider(MNEMONIC, "https://data-seed-prebsc-1-s1.binance.org:8545", AccountIndex);
      },
      network_id: 97
    }
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.14",      // Fetch exact version from solc-bin (default: truffle's version)
    }
  },
};
