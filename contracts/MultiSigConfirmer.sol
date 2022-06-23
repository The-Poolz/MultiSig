// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";

/// @title contains confirmation requests.
contract MultiSigConfirmer is MultiSigInitiator {
    /// @dev only authorized address can change himself
    function ChangeAuthorizedAddress(address authorize)
        external
        OnlyAuthorized
    {
        require(
            !AuthorizedMap[authorize],
            "AuthorizedMap must have unique addresses"
        );
        require(authorize != address(0), "Authorize address must be non-zero");
        emit AuthorizedChanged(authorize, msg.sender);
        AuthorizedMap[msg.sender] = false;
        AuthorizedMap[authorize] = true;
    }

    /// @dev collects votes to confirm mint tokens
    /// if there are enough votes, coins will be minted
    function ConfirmMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(target, amount)
    {
        _confirmMint(target, amount);
    }

    /// @dev transfers the right to mint tokens
    function ConfirmTransferOwnership(address target)
        external
        OnlyAuthorized
        ValuesCheck(target, 0)
    {
        _confirmTransferOwnership(target);
    }
}
