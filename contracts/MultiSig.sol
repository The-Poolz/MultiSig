// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenInterface.sol";

contract MultiSig {
    address public TokenAddress; //will change only in constractor
    address public InitiatorAddress; //can self change
    address public ConfirmerAddress; //can self change
    uint256 public Amount; //hold temp data for transaction
    address public TargetAddress;  //hold temp data for transaction

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

    modifier OnlyConfirmerOrInitiator() {
        require(
            msg.sender == InitiatorAddress || msg.sender == ConfirmerAddress,
            "only the InitiationAddress or ConfirmerAddress can change it"
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
        require(amount > 0 && target != address(0));
        Amount = amount;
        TargetAddress = target;
    }

    function ConfirmMint(uint256 amount, address target) public OnlyConfirmer {
        require(
            Amount == amount && TargetAddress == target,
            "Must use the same values from initiation"
        );
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

    function ConfirmTransferOwnership(address target) public OnlyConfirmer {
        require(
            TargetAddress == target && Amount == 0,
            "Must use the same values from initiation"
        );
        IERC20(TokenAddress).addMiner(target);
        IERC20(TokenAddress).renounceMinter();
        ClearConfirmation();
    }

    function ClearConfirmation() public OnlyConfirmerOrInitiator {
        Amount = 0;
        TargetAddress = address(0);
    }
}
