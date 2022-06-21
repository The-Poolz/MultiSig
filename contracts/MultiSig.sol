// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenInterface.sol";
import "./MultySigModifiers.sol";

contract MultiSig is MultySigModifiers {
    constructor(
        address Initiator,
        address Confirmer,
        address Token
    ) {
        InitiatorAddress = Initiator;
        ConfirmerAddress = Confirmer;
        TokenAddress = Token;
    }

    function ChangeInitiationAddress(address Initiation) public OnlyInitiator {
        require(Initiation != ConfirmerAddress, "can't have same address");
        require(Initiation != address(0));
        InitiatorAddress = Initiation;
    }

    function ChangeConfirmerAddress(address Confirmer) public OnlyConfirmer {
        require(Confirmer != InitiatorAddress, "can't have same address");
        require(Confirmer != address(0));
        ConfirmerAddress = Confirmer;
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

    function ConformMint(uint256 amount, address target)
        public
        OnlyConfirmer
        ValuesCheck(target, amount)
    {
        IERC20(TokenAddress).mint(target, amount);
        ClearConfirmation();
    }

    function InitiateTransferOwnership(address target)
        public
        OnlyInitiator
        NoInitiation
    {
        require(target != address(0));
        TargetAddress = target;
    }

    function ConformTransferOwnership(address target)
        public
        OnlyConfirmer
        ValuesCheck(target, 0)
    {
        IERC20(TokenAddress).addMiner(target);
        IERC20(TokenAddress).renounceMinter();
        TargetAddress = address(0);
    }

    function ClearConfirmation() public OnlyConfirmerOrInitiator {
        Amount = 0;
        TargetAddress = address(0);
    }
}
