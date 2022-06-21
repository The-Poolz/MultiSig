const { assert } = require('chai')
const truffleAssert = require('truffle-assertions')
const BigNumber = require("bignumber.js")
const constants = require('@openzeppelin/test-helpers/src/constants.js')
const { inTransaction } = require('@openzeppelin/test-helpers/src/expectEvent')
const Token = artifacts.require("ERC20Token")
const MultiSig = artifacts.require("MultiSig")

contract("MultiSig", accounts => {
    const initiatorAddress = accounts[1], confirmerAddress = accounts[2]
    let token
    let multiSig

    before(async () => {
        token = await Token.new('TEST', 'TEST')
        multiSig = await MultiSig.new(initiatorAddress, confirmerAddress, token.address)
        const multiToken = await multiSig.TokenAddress()
        const initiator = await multiSig.InitiatorAddress()
        const confirmer = await multiSig.ConfirmerAddress()
        assert.equal(multiToken, token.address)
        assert.equal(initiator, initiatorAddress)
        assert.equal(confirmer, confirmerAddress)
    })

    describe('Manageable', () => {
        it('should change initiation address', async () => {
            const newInitiatorAddress = accounts[3]
            await multiSig.ChangeInitiationAddress(newInitiatorAddress, { from: initiatorAddress })
            const initiator = await multiSig.InitiatorAddress()
            assert.notEqual(initiator, initiatorAddress)
            assert.equal(initiator, newInitiatorAddress)
            await multiSig.ChangeInitiationAddress(initiatorAddress, { from: newInitiatorAddress })
        })

        it('should change confirmer address', async () => {
            const newСonfirmerAddress = accounts[3]
            await multiSig.ChangeConfirmerAddress(newСonfirmerAddress, { from: confirmerAddress })
            const confirmer = await multiSig.ConfirmerAddress()
            assert.notEqual(confirmer, confirmerAddress, 'invalid ')
            assert.equal(confirmer, newСonfirmerAddress)
            await multiSig.ChangeConfirmerAddress(confirmerAddress, { from: newСonfirmerAddress })
        })
    })

    describe('Accessibility', () => {
        it('should revert with wrong rights', async () => {
            const invalidAddr = accounts[0]
            await truffleAssert.reverts(
                multiSig.ChangeInitiationAddress(accounts[1], { from: invalidAddr }), 'only the InitiationAddress can change it')
            await truffleAssert.reverts(
                multiSig.ChangeConfirmerAddress(accounts[1], { from: invalidAddr }), 'only the ConfirmerAddress can change it')
        })
    })
})