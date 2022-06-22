// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultySigModifiers.sol";

/// @title contains all request initiations.
contract MultiSigInitiator is MultySigModifiers {
    /// @dev initiate a request to mint tokens
    function InitiateMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
        require(amount > 0 && target != address(0));
        Amount = amount;
        TargetAddress = target;
        emit StartMint(target, amount);
    }

    /// @dev initiate a change of ownership of minting tokens
    function InitiateTransferOwnership(address target)
        external
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
        require(target != address(0));
        TargetAddress = target;
        emit StartChangeOwner(target);
    }
}
