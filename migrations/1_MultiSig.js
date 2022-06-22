const MultiSig = artifacts.require("MultiSig")
const constants = require("@openzeppelin/test-helpers/src/constants")

module.exports = function (deployer) {
  deployer.deploy(MultiSig, ['0xdf32320E237B09b31c249c4326Caa54684ba5D45', '0xD404b96eD84aD0d4916eca1aEE86443F48dA9aaa'], '0x309D438504Daf29Ae9b3af628DAAe963f2eb996e', 2)
  //constructor(address[] memory Authorized, address Token, uint256 MinSignersAmount)
}
