const MultiSig = artifacts.require("MultiSig")
const constants = require("@openzeppelin/test-helpers/src/constants")

module.exports = function (deployer) {
  deployer.deploy(MultiSig, [constants.ZERO_ADDRESS, constants.ZERO_ADDRESS], '0x309D438504Daf29Ae9b3af628DAAe963f2eb996e', 2)
  // constructor(
  //   address[] memory Authorized, // who can votes and initiate mint transaction
  //   address Token, // mintable token address
  //   uint256 MinSignersAmount // minimum amount of votes for a successful mint transaction 
  // )
}
