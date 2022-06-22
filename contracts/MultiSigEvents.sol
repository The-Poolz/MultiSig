// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigEvents {
    event StartMint(address target, uint256 amount);
    event CompliteMint(address target, uint256 amount);
    event StartChangeOwner(address target);
    event CompliteChangeOwner(address target);
    event ConfirmerChanged(address[] newConfirmers, address[] OldConfirmers);
    event InitiatorChanged(address newInitiator, address OldInitiator);
    event Clear();
}