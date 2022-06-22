// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultySigModifiers.sol";

contract MultiSigInitiator is MultySigModifiers {
    function InitiateMint(address target, uint256 amount)
        public
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
        require(amount > 0 && target != address(0));
        Amount = amount;
        TargetAddress = target;
        emit StartMint(target, amount);
    }

    function InitiateTransferOwnership(address target)
        public
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
        require(target != address(0));
        TargetAddress = target;
        emit StartChangeOwner(target);
    }
}
