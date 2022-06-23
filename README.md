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

2. The second you have to start a vote by using InitiateMint() function.
   Where you have to pass target address and amount of tokens. 
   During the sending of transaction it will be emitted a StartMint event.
```console
    event StartMint(address target, uint256 amount);
```
```console
    function InitiateMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
```

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
