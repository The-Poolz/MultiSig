// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultySigModifiers {
    address public TokenAddress; //will change only in constractor
    address public InitiatorAddress; //can self change
    address public ConfirmerAddress; //can self change
    uint256 public Amount; //hold temp data for transaction
    address public TargetAddress; //hold temp data for transaction

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

    modifier ValuesCheck(address target, uint256 amount) {
        require(
            TargetAddress == target && Amount == amount,
            "Must use the same values from initiation"
        );
        _;
    }
}