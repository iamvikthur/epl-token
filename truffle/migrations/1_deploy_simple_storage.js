const EPLToken = artifacts.require("EPL")
const EPLICO = artifacts.require("EPLICO")

require('dotenv').config({path: '../.env'})

module.exports = async function (deployer) {
    await deployer.deploy(EPLToken);
    await deployer.deploy(EPLICO, process.env.ICO_TOKEN_ADDRESS);
} 