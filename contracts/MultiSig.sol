// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigConfirmer.sol";

/// @author The-Poolz contract team
/// @title Smart contract of using multi signature for approval sending transactions.
contract MultiSig is MultiSigConfirmer {
    constructor(
        address[] Authorized, // who can votes and initiate mint transaction
        address Token, // mintable token address
        uint256 MinSignersAmount // minimum amount of votes for a successful mint transaction 
    ) {
        require(Authorized.length >= MinSignersAmount);
        require(Token != address(0));
        for (uint256 index = 0; index < Authorized.length; index++) {
            AuthorizedMap[Authorized[index]] = true;
        }
        TokenAddress = Token;
        MinSigners = MinSignersAmount;
    }
}
