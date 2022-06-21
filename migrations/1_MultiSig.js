const MultiSig = artifacts.require("MultiSig")
const constants = require("@openzeppelin/test-helpers/src/constants")

module.exports = function (deployer) {
  deployer.deploy(MultiSig, constants.ZERO_ADDRESS, constants.ZERO_ADDRESS, constants.ZERO_ADDRESS)
  //constructor(address Initiator, address Confirmer, address Token)
}
