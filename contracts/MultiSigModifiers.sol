// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenInterface.sol";

/// @title contains all modifiers and stores variables.
contract MultiSigModifiers {
    address public TokenAddress; //will change only in constractor
    uint256 public MinSigners; //min signers amount to do action - will change only in constractor
    uint256 public sigCounter; //vote count if the transaction can be implemented
    mapping(address => bool) public AuthorizedMap; //can self change
    mapping(uint => address) public VotesMap; // who voted
    uint256 public Amount; //hold temp data for transaction
    address public TargetAddress; //hold temp data for transaction

    modifier OnlyAuthorized() {
        require(
            AuthorizedMap[msg.sender],
            "User is not Authorized"
        );
        _;
    }

    modifier onlyMinter() {
        require(
            IERC20(TokenAddress).isMinter(address(this)),
            "MultiSig does not have a minter role"
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

    modifier NotVoted(){
        for (uint256 i = 0; i < sigCounter; i++) {
            require(VotesMap[i] != msg.sender, "your vote is already accepted");
        }
        _;
    }
}
