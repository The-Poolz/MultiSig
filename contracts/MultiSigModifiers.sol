// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigEvents.sol";

/// @title contains all modifiers and stores variables.
contract MultiSigModifiers is MultiSigEvents {
    address public TokenAddress; //will change only in constractor
    mapping(address => bool) public AuthorizedMap; //can self change
    uint256 public Amount; //hold temp data for transaction
    uint256 public MinSigners; //min signers amount to do action
    address public TargetAddress; //hold temp data for transaction

    modifier OnlyAuthorized() {
        require(
            AuthorizedMap[msg.sender],
            "User is not Authorized"
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
