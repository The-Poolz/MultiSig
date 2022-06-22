// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title contains all events.
contract MultiSigEvents {
    event StartMint(address target, uint256 amount);
    event CompleteMint(address target, uint256 amount);
    event StartChangeOwner(address target);
    event CompleteChangeOwner(address target);
    event AuthorizedChanged(address newAuthorize, address OldAuthorize);
    event NewSig(address Signer, uint256 CurrentSigns, uint256 NeededSigns);
    event Clear();
}