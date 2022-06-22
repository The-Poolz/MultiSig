const { assert } = require('chai')
const truffleAssert = require('truffle-assertions')
const BigNumber = require("bignumber.js")
const constants = require('@openzeppelin/test-helpers/src/constants.js')
const { inTransaction } = require('@openzeppelin/test-helpers/src/expectEvent')
const Token = artifacts.require("ERC20Token")
const MultiSig = artifacts.require("MultiSig")

contract("MultiSig", accounts => {
    const authorizedAddresses = [accounts[1], accounts[2], accounts[7]]
    const initiatorAddress = accounts[1]
    const confirmerAddress = accounts[2]
    const invalidAddr = accounts[0]
    const mintAddr = accounts[4]
    const amount = '10000'
    let token
    let multiSig

    before(async () => {
        token = await Token.new()
        multiSig = await MultiSig.new(authorizedAddresses, token.address, 2)
        const multiToken = await multiSig.TokenAddress()

        const minSigners = await multiSig.MinSigners()
        assert.equal(minSigners, 2)
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
        const target = await multiSig.TargetAddress()
        await multiSig.ConfirmMint(mintAddr, amount, { from: confirmerAddress })
        const tx = await multiSig.ConfirmMint(mintAddr, amount, { from: accounts[7] })
        const mintedSupply = new BigNumber(await token.totalSupply())
        const confirmAmount = tx.logs[1].args.amount
        const actualAmount = await multiSig.Amount()
        const actualTarget = await multiSig.TargetAddress()
        assert.equal(actualAmount, '0')
        assert.equal(actualTarget, constants.ZERO_ADDRESS, 'invalid actual address')
        assert.equal(target, mintAddr)
        assert.equal(confirmAmount, amount)
        assert.equal(mintedSupply.toString(), BigNumber.sum(totalSupply, amount).toString(), 'invalid total balance')
    })

    describe('Manageable', () => {
        it('should change authorized address', async () => {
            const newAuthorizedAddress = accounts[3]
            truffleAssert.eventEmitted(
                await multiSig.ChangeAuthorizedAddress(newAuthorizedAddress, { from: initiatorAddress }),
                 'AuthorizedChanged');
            truffleAssert.eventEmitted(
                await multiSig.ChangeAuthorizedAddress(initiatorAddress, { from: newAuthorizedAddress }),
                 'AuthorizedChanged');
        })
    })

    describe('Accessibility', () => {
        it('should revert with wrong rights', async () => {
            await truffleAssert.reverts(
                multiSig.ChangeAuthorizedAddress(accounts[1], { from: invalidAddr }), 'User is not Authorized')
            await truffleAssert.reverts(
                multiSig.InitiateTransferOwnership(accounts[1], { from: invalidAddr }), 'User is not Authorized')
            await truffleAssert.reverts(
                multiSig.ConfirmTransferOwnership(accounts[1], { from: invalidAddr }), 'User is not Authorized')
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[1], '1000', { from: invalidAddr }), 'User is not Authorized')
            await truffleAssert.reverts(
                multiSig.InitiateMint(accounts[1], '1000', { from: invalidAddr }), 'User is not Authorized')
            await truffleAssert.reverts(
                multiSig.ClearConfirmation({ from: invalidAddr }), 'User is not Authorized')
        })

        it('should revert with the same values', async () => {
            await multiSig.ClearConfirmation({ from: initiatorAddress })
            await multiSig.InitiateMint(mintAddr, amount, { from: initiatorAddress })
            await truffleAssert.reverts(
                multiSig.ConfirmMint(mintAddr, '999', { from: confirmerAddress }), 'Must use the same values from initiation')
            await truffleAssert.reverts(
                multiSig.ConfirmMint(accounts[2], amount, { from: confirmerAddress }), 'Must use the same values from initiation')
            await multiSig.ConfirmMint(mintAddr, amount, { from: confirmerAddress })
            await truffleAssert.reverts(
                multiSig.ConfirmTransferOwnership(confirmerAddress, { from: confirmerAddress }), 'Must use the same values from initiation')
        })
    })

    describe('change ownership to mint', () => {
        it('should initiate transfer ownership', async () => {
            const newTarget = accounts[5]
            await multiSig.ClearConfirmation({ from: initiatorAddress })
            const tx = await multiSig.InitiateTransferOwnership(newTarget, { from: initiatorAddress })
            const target = tx.logs[0].args.target
            assert.equal(target, newTarget)
        })

        it('should confirm transfer ownership', async () => {
            const newTarget = accounts[5]
            await multiSig.ConfirmTransferOwnership(newTarget, { from: confirmerAddress })
            const tx = await multiSig.ConfirmTransferOwnership(newTarget, { from: confirmerAddress })
            const target = tx.logs[tx.logs.length - 2].args.target
            assert.equal(target, newTarget)
            await multiSig.InitiateMint(mintAddr, amount, { from: initiatorAddress })
            await multiSig.ConfirmMint(mintAddr, amount, { from: confirmerAddress })
            await truffleAssert.reverts(multiSig.ConfirmMint(mintAddr, amount, { from: confirmerAddress }), "MinterRole: caller does not have the Minter role")
        })
    })
})