const MultiSig = artifacts.require("MultiSig")
const constants = require("@openzeppelin/test-helpers/src/constants")

module.exports = function (deployer) {
  deployer.deploy(MultiSig, [constants.ZERO_ADDRESS, constants.ZERO_ADDRESS], constants.ZERO_ADDRESS, 2)
  //constructor(address[] memory Authorized, address Token, uint256 MinSignersAmount)
}
