// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultySig {
    address InitiationAddress;
    address ConfirmerAddress;

    constructor(address Initiation, address Confirmer) {
        InitiationAddress = Initiation;
        ConfirmerAddress = Confirmer;
    }

    function ChangeInitiationAddress(address Initiation) public
    {
        require(Initiation != ConfirmerAddress); //can't have same address
        require(msg.sender == InitiationAddress); //only the InitiationAddress can cahnbge it
        InitiationAddress = Initiation;
    }

    function ChangeConfirmerAddress(address Confirmer) public
    {
        require(Confirmer != InitiationAddress); //can't have same address
        require(msg.sender == ConfirmerAddress); //only the InitiationAddress can cahnbge it
        ConfirmerAddress = Confirmer;
    }
}
