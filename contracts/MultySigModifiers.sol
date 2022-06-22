// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigEvents.sol";

contract MultySigModifiers is MultiSigEvents{
    address public TokenAddress; //will change only in constractor
    address public InitiatorAddress; //can self change
    address[] public ConfirmersAddresses; //can self change
    uint256 public Amount; //hold temp data for transaction
    uint256 public MinSigners;
    address public TargetAddress; //hold temp data for transaction
    mapping(address => bool) public IsSigned;
    bool isSigner = false;

    modifier OnlyInitiator() {
        require(
            msg.sender == InitiatorAddress,
            "only the InitiationAddress can change it"
        );
        _;
    }

    modifier OnlyConfirmerOrInitiator() {
        CheckOnlyConfirmer();
        require(
            msg.sender == InitiatorAddress || isSigner,
            "only the InitiationAddress or ConfirmerAddress can change it"
        );
        isSigner = false;
        _;
    }

    modifier OnlyConfirmer() {
        CheckOnlyConfirmer();
        require(
            isSigner,
            "only the ConfirmerAddress can change it"
        );
        isSigner = false;
        _;
    }

    modifier ValuesCheck(address target, uint256 amount) {
        require(
            TargetAddress == target && Amount == amount,
            "Must use the same values from initiation"
        );
        _;
    }

    function CheckOnlyConfirmer() private {
        for (uint256 i = 0; i < ConfirmersAddresses.length; i++) {
            if (ConfirmersAddresses[i] == msg.sender) {
                isSigner = true;
            }
        }
    }
}
