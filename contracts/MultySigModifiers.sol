// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigEvents.sol";

contract MultySigModifiers is MultiSigEvents {
    address public TokenAddress; //will change only in constractor
    mapping(uint256 => address) AuthorizedMap; //can self change
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

    modifier ValuesCheck(address target, uint256 amount) {
        require(
            TargetAddress == target && Amount == amount,
            "Must use the same values from initiation"
        );
        _;
    }
}
