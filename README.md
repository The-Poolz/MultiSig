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
truffle migrate --network dashboard
```

### How to use?
1. First of all you have to set the minter in the token contract as the contract address.
   You can use addMinter() function.
```console
  function addMinter(address account) public onlyMinter {
        _addMinter(account);
  }
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0x27e549b383d54042be1b008265fc09dd101a2b1b9e172270182446595f40fc99)

2. The second you have to start a vote by using InitiateMint() function.
   Where you have to pass target address and amount of tokens. 
```console
    function InitiateMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
```
   During the sending of transaction it will be emitted a StartMint event.
```console
    event StartMint(address target, uint256 amount);
```
Testnet tx: [link](https://rinkeby.etherscan.io/tx/0x661a785f3b1c9d0c488470c0c636a61f8764b423ceb14aa8cfc52799532b8d9c)

3. After that you have to confirm action from amount of confirmer's address, which pointed in MinSigners variable.
   You can do this by using ConfirmMint() function.
   If there are enough votes, coins will be minted.
```console
    function ConfirmMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(target, amount)
    {
```
Testnet tx: [link](https://testnet.bscscan.com/tx/0x785c017d46639a662a55f40abf3d2fda1827f0c7ddb0341e78d98e17c80106c3)
