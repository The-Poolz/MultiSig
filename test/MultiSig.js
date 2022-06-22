const { assert } = require('chai')
const truffleAssert = require('truffle-assertions')
const BigNumber = require("bignumber.js")
const constants = require('@openzeppelin/test-helpers/src/constants.js')
const { inTransaction } = require('@openzeppelin/test-helpers/src/expectEvent')
const Token = artifacts.require("ERC20Token")
const MultiSig = artifacts.require("MultiSig")

contract("MultiSig", accounts => {
    const initiatorAddress = accounts[1], confirmerAddress = accounts[2]
    const invalidAddr = accounts[0]
    let token
    let multiSig

    before(async () => {
        token = await Token.new()
        multiSig = await MultiSig.new(initiatorAddress, confirmerAddress, token.address)
        const multiToken = await multiSig.TokenAddress()
        const initiator = await multiSig.InitiatorAddress()
        const confirmer = await multiSig.ConfirmerAddress()
        assert.equal(multiToken, token.address)
        assert.equal(initiator, initiatorAddress)
        assert.equal(confirmer, confirmerAddress)
        await token.addMinter(multiSig.address)// multiSig added as minter
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
            await truffleAssert.reverts(
                multiSig.ChangeInitiationAddress(accounts[1], { from: invalidAddr }), 'only the InitiationAddress can change it')
            await truffleAssert.reverts(
                multiSig.ChangeConfirmerAddress(accounts[1], { from: invalidAddr }), 'only the ConfirmerAddress can change it')
            await truffleAssert.reverts(
                multiSig.InitiateTransferOwnership(accounts[1], { from: invalidAddr }), 'only the InitiationAddress can change it')
            await truffleAssert.reverts(
                multiSig.ConfirmTransferOwnership(accounts[1], { from: invalidAddr }), 'only the ConfirmerAddress can change it')
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[1], '1000', { from: invalidAddr }), 'only the ConfirmerAddress can change it')
            await truffleAssert.reverts(
                multiSig.InitiateMint(accounts[1], '1000',  { from: invalidAddr }), 'only the InitiationAddress can change it')
            await truffleAssert.reverts(
                multiSig.ClearConfirmation({ from: invalidAddr }), 'only the InitiationAddress or ConfirmerAddress can change it')
        })

        it('should revert with the same values', async () => {
            await multiSig.InitiateMint(accounts[1], '1000',  { from: initiatorAddress })
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[1], '999', { from: confirmerAddress }), 'Must use the same values from initiation')
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[2], '1000', { from: confirmerAddress }), 'Must use the same values from initiation')
            await multiSig.ConfirmMint(accounts[1], '1000', { from: confirmerAddress })
            await truffleAssert.reverts(
                multiSig.ConfirmTransferOwnership(confirmerAddress, { from: confirmerAddress }), 'Must use the same values from initiation')
        })
    })
})