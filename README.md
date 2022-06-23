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
Testnet tx: [link](https://testnet.bscscan.com/tx/0xf6cfd8624de13f07478de5189dae7e5695d563f5af2d948a301902b89707c35b)

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
Testnet tx: [link](https://testnet.bscscan.com/tx/0x298d3484e9532ecddabf3d2d578f5a138d2c53e2585bec96bf89c7ec6192d159)

3. After that you have to confirm action from each confirmer's address, which pointed in authorized addresses.
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
