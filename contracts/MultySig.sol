// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenInterface.sol";

contract MultySig {
    address InitiationAddress;
    address ConfirmerAddress;
    uint256 Amount;
    address TargetAddress;
    address TokenAddress;

    constructor(address Initiation, address Confirmer, address Token) {
        InitiationAddress = Initiation;
        ConfirmerAddress = Confirmer;
        TokenAddress = Token;
    }

    function ChangeInitiationAddress(address Initiation) public {
        require(Initiation != ConfirmerAddress, "can't have same address");
        require(
            msg.sender == InitiationAddress,
            "only the InitiationAddress can change it"
        );
        InitiationAddress = Initiation;
    }

    function ChangeConfirmerAddress(address Confirmer) public {
        require(Confirmer != InitiationAddress, "can't have same address");
        require(
            msg.sender == ConfirmerAddress,
            "only the InitiationAddress can cahnbge it"
        );
        ConfirmerAddress = Confirmer;
    }

    function InitiateMint(uint256 amount, address target) public {
        require(
            msg.sender == InitiationAddress,
            "only the InitiationAddress can do this"
        );
        require(
            Amount == 0 && TargetAddress == address(0),
            "Must not be initiated"
        );
        Amount = amount;
        TargetAddress = target;
    }

    function ConformMint(uint256 amount, address target) public {
        require(
            msg.sender == ConfirmerAddress,
            "only the ConfirmerAddress can do this"
        );
        require(Amount == amount && TargetAddress == target,"Must use the same values from initiation");
        IERC20(TokenAddress).mint(target,amount);
        Amount = 0;
        TargetAddress = address(0);
    }
}
