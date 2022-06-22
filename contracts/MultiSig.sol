// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigConfirmer.sol";

contract MultiSig is MultiSigConfirmer {
    constructor(
        address Initiator,
        address Confirmer,
        address Token
    ) {
        InitiatorAddress = Initiator;
        ConfirmerAddress = Confirmer;
        TokenAddress = Token;
    }
}
