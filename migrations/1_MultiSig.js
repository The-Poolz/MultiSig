const MultiSig = artifacts.require("MultiSig")

module.exports = function (deployer) {
  deployer.deploy(MultiSig, ['0x6063fBa0fBd645d648C129854Cce45A70dd89691', '0xae5a95913137809cA0c8873Aa95E6BFa75176245'], '0x05F2FE17CE7c8FbC1a72a29F256F8ca2dD83Ef82', 2)
  //constructor(address Initiator, address Confirmer, address Token)
}