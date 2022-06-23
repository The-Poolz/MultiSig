const MultiSig = artifacts.require("MultiSig")
const constants = require("@openzeppelin/test-helpers/src/constants")
const authorizeArray = ['0x6063fBa0fBd645d648C129854Cce45A70dd89691', '0xae5a95913137809cA0c8873Aa95E6BFa75176245']
const tokenAddress = '0x05F2FE17CE7c8FbC1a72a29F256F8ca2dD83Ef82'
const SigCountNeed = 2

module.exports = function (deployer) {
  deployer.deploy(MultiSig, authorizeArray, tokenAddress, SigCountNeed)
  //constructor(address Initiator, address Confirmer, address Token)
}
