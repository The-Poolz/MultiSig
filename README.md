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
truffle migrate --f 1 --to 1 --network dashboard 
```

### How to use?
1. First of all, you should set the MultiSig contract as a minter role using the mintable token contract.
   <br>You should use the addMinter() function.
```solidity
  function addMinter(address account) external;
```
Testnet tx: [link](https://testnet.bscscan.com/tx/0xf6cfd8624de13f07478de5189dae7e5695d563f5af2d948a301902b89707c35b)

2. The second you have to start a vote by using InitiateMint() function.
   Where you have to pass target address and amount of tokens. 
```solidity
    function InitiateMint(address target, uint256 amount) external;
```
   During the sending of transaction it will be emitted a StartMint event.
```solidity
    event StartMint(address target, uint256 amount);
```
Testnet tx: [link](https://testnet.bscscan.com/tx/0x298d3484e9532ecddabf3d2d578f5a138d2c53e2585bec96bf89c7ec6192d159)

3. After that you have to confirm action from amount of confirmer's address, which pointed in MinSigners variable.
   You can do this by using ConfirmMint() function.
   If there are enough votes, coins will be minted.
```solidity
    function ConfirmMint(address target, uint256 amount) external;
```
Testnet tx: [link](https://testnet.bscscan.com/tx/0x785c017d46639a662a55f40abf3d2fda1827f0c7ddb0341e78d98e17c80106c3)
