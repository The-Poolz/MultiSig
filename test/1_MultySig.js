const { assert } = require('chai')
const truffleAssert = require('truffle-assertions')
const BigNumber = require("bignumber.js")
const constants = require('@openzeppelin/test-helpers/src/constants.js')
const Token = artifacts.require("ERC20Token")

// potentially needs to be moved to Integrate repo
contract("MultiSig", accounts => {
    const initiatorAddress = accounts[1], ConfirmerAddress = accounts[2]
    let token

    before(async () => {
        token = await Token.new('TEST', 'TEST')
    })

})