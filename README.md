# MultiSig
[![Build Status](https://app.travis-ci.com/The-Poolz/MultiSig.svg?token=j64fMSARWGtzysprUKZK&branch=master)](https://app.travis-ci.com/The-Poolz/MultiSig)
[![codecov](https://codecov.io/gh/The-Poolz/MultiSig/branch/master/graph/badge.svg?token=619oKb6Wsk)](https://codecov.io/gh/The-Poolz/MultiSig)

Smart contract of using multi signature for approval sending transactions.

### Installation

```console
npm install
```

### Testing

```console
truffle run coverage
```
### Deploy

```console
truffle dashboard
```
```console
truffle migrate --network dashboard
```

## How to mint?
**1.** First of all, you should set the MultiSig contract as a minter role using the mintable token contract.
   <br>You should use the addMinter() function.
```solidity
  function addMinter(address account) external;
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0xb970ba50ec036642759f0dc3152a31b095313aa29a4a35c8ee6e7a071c938ad8)

**2.** The second you have to start a vote by using InitiateMint() function.
   Where you have to pass target address and amount of tokens. 
```solidity
    function InitiateMint(address target, uint256 amount) external;
```
   During the sending of transaction it will be emitted a StartMint event.
```solidity
    event StartMint(address target, uint256 amount);
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0x4b536a63f2aad04f829274731b81ebb67a118345090deb166c50853b168cfaa8)

**3.** After that you have to confirm action from amount of confirmer's address, which pointed in MinSigners variable.
   You can do this by using ConfirmMint() function.
   If there are enough votes, coins will be minted.
```solidity
    function ConfirmMint(address target, uint256 amount) external;
```
Testnet tx: [link](https://testnet.bscscan.com/tx/0x785c017d46639a662a55f40abf3d2fda1827f0c7ddb0341e78d98e17c80106c3)



## FAQs

* Do you need to cancel a transaction request?

   You should use the ClearConfirmation() function.
```solidity
    function ClearConfirmation() public;
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0xaa07b87cb97a1d6c24d52fb00b445a6d5d0805aed1d8c6375ef2e6955c92ced3)

* Do you need to change your authorized address to another?

   You should use ChangeAuthorizedAddress() function.
```solidity
    function ChangeAuthorizedAddress(address authorize) external;
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0x7eeea83ca80c654cf59c9155db2991ce41298cf266d14b90e111ab6b6cbce682)

* Do you need to transfer ownership address to another?

   You should use InitiateTransferOwnership() function.
```solidity
    function InitiateTransferOwnership(address target) external;
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0xa07d1b1a4bc5939f1df0b6ed5e9c4ccfcb1ea1159b0155c11e8ccc388e5cd623)

   After that, you need to collect the required number of votes. The ConfirmTransferOwnership() function allows members to vote. If the required number of votes is        obtained, the rights will be transferred.
```solidity
    function ConfirmTransferOwnership(address target) external;
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0xe6e329608dca88c09163c681a43e4b1f93da0d7ed105f74ef3e40d9b35e3cbd5)
