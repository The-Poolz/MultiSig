// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenInterface.sol";

contract MultySig {
    address InitiatorAddress;
    address ConfirmerAddress;
    uint256 Amount;
    address TargetAddress;
    address TokenAddress;

    constructor(
        address Initiator,
        address Confirmer,
        address Token
    ) {
        InitiatorAddress = Initiator;
        ConfirmerAddress = Confirmer;
        TokenAddress = Token;
    }

    modifier OnlyInitiator() {
        require(
            msg.sender == InitiatorAddress,
            "only the InitiationAddress can change it"
        );
        _;
    }

    modifier OnlyConfirmer() {
        require(
            msg.sender == ConfirmerAddress,
            "only the ConfirmerAddress can change it"
        );
        _;
    }

    modifier NoInitiation() {
        require(
            Amount == 0 && TargetAddress == address(0),
            "Must not be initiated"
        );
        _;
    }

    function ChangeInitiationAddress(address Initiation) public OnlyInitiator {
        require(Initiation != ConfirmerAddress, "can't have same address");
        InitiatorAddress = Initiation;
    }

    function ChangeConfirmerAddress(address Confirmer) public OnlyConfirmer {
        require(Confirmer != InitiatorAddress, "can't have same address");
        ConfirmerAddress = Confirmer;
    }

    function InitiateMint(uint256 amount, address target)
        public
        OnlyInitiator
        NoInitiation
    {
        Amount = amount;
        TargetAddress = target;
    }

    function ConformMint(uint256 amount, address target) public OnlyConfirmer {
        require(
            Amount == amount && TargetAddress == target,
            "Must use the same values from initiation"
        );
        IERC20(TokenAddress).mint(target, amount);
        Amount = 0;
        TargetAddress = address(0);
    }

    function InitiateTransferOwnership(address target)
        public
        OnlyInitiator
        NoInitiation
    {
        TargetAddress = target;
    }

    function ConformTransferOwnership(address target) public OnlyConfirmer {
        require(
            TargetAddress == target,
            "Must use the same values from initiation"
        );
        IERC20(TokenAddress).addMiner(target);
        IERC20(TokenAddress).renounceMinter();
        TargetAddress = address(0);
    }
}
