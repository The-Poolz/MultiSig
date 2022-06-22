const { assert } = require('chai')
const truffleAssert = require('truffle-assertions')
const BigNumber = require("bignumber.js")
const constants = require('@openzeppelin/test-helpers/src/constants.js')
const { inTransaction } = require('@openzeppelin/test-helpers/src/expectEvent')
const Token = artifacts.require("ERC20Token")
const MultiSig = artifacts.require("MultiSig")

contract("MultiSig", accounts => {
    const initiatorAddress = accounts[1], confirmerAddress = accounts[2]
    const invalidAddr = accounts[0], mintAddr = accounts[4]
    const amount = '10000'
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
        await token.renounceMinter()
    })

    it('should initiate minting', async () => {
        const tx = await multiSig.InitiateMint(mintAddr, amount, { from: initiatorAddress })
        const target = tx.logs[tx.logs.length - 1].args.target
        const initiateAmount = tx.logs[tx.logs.length - 1].args.amount
        assert.equal(target, mintAddr)
        assert.equal(initiateAmount, amount)
    })

    it('should confirm mint', async () => {
        const totalSupply = new BigNumber(await token.totalSupply())
        const tx = await multiSig.ConfirmMint(mintAddr, amount, { from: confirmerAddress })
        const mintedSupply = new BigNumber(await token.totalSupply())
        const target = tx.logs[0].args.target
        const confirmAmount = tx.logs[0].args.amount
        const actualAmount = await multiSig.Amount()
        const actualTarget = await multiSig.TargetAddress()
        assert.equal(actualAmount, '0', 'invalid actual address')
        assert.equal(actualTarget, constants.ZERO_ADDRESS, 'invalid actual address')
        assert.equal(target, mintAddr)
        assert.equal(confirmAmount, amount)
        assert.equal(mintedSupply.toString(), BigNumber.sum(totalSupply, amount).toString(), 'invalid total balance')
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
            assert.notEqual(confirmer, confirmerAddress)
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
                multiSig.InitiateMint(accounts[1], '1000', { from: invalidAddr }), 'only the InitiationAddress can change it')
            await truffleAssert.reverts(
                multiSig.ClearConfirmation({ from: invalidAddr }), 'only the InitiationAddress or ConfirmerAddress can change it')
        })

        it('should revert with the same values', async () => {
            await multiSig.InitiateMint(accounts[1], '1000', { from: initiatorAddress })
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[1], '999', { from: confirmerAddress }), 'Must use the same values from initiation')
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[2], '1000', { from: confirmerAddress }), 'Must use the same values from initiation')
            await multiSig.ConfirmMint(accounts[1], '1000', { from: confirmerAddress })
            await truffleAssert.reverts(
                multiSig.ConfirmTransferOwnership(confirmerAddress, { from: confirmerAddress }), 'Must use the same values from initiation')
        })
    })

    describe('change ownership to mint', () => {
        it('should initiate transfer ownership', async () => {
            const newTarget = accounts[5]
            const tx = await multiSig.InitiateTransferOwnership(newTarget, { from: initiatorAddress })
            const target = tx.logs[0].args.target
            assert.equal(target, newTarget)
        })

        it('should confirm transfer ownership', async () => {
            const newTarget = accounts[5]
            const tx = await multiSig.ConfirmTransferOwnership(newTarget, { from: confirmerAddress })
            const target = tx.logs[0].args.target
            assert.equal(target, newTarget)
            await multiSig.InitiateMint(mintAddr, amount, { from: initiatorAddress })
            await truffleAssert.reverts(multiSig.ConfirmMint(mintAddr, amount, { from: confirmerAddress }), "MinterRole: caller does not have the Minter role")
        })
    })
})