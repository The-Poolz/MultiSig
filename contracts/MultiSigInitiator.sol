// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultySigModifiers.sol";

contract MultiSigInitiator is MultySigModifiers {
    function ChangeInitiationAddress(address Initiation) public OnlyInitiator {
        require(Initiation != ConfirmerAddress, "can't have same address");
        require(Initiation != address(0));
        InitiatorAddress = Initiation;
    }

    function InitiateMint(uint256 amount, address target)
        public
        OnlyInitiator
        NoInitiation
    {
        require(amount > 0 && target != address(0));
        Amount = amount;
        TargetAddress = target;
    }

    function InitiateTransferOwnership(address target)
        public
        OnlyInitiator
        NoInitiation
    {
        require(target != address(0));
        TargetAddress = target;
    }
}
