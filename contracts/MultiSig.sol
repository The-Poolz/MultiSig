// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigConfirmer.sol";

contract MultiSig is MultiSigConfirmer {
    constructor(
        address[] memory Authorized,
        address Token,
        uint256 MinSignersAmount
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
