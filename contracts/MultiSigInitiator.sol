// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigModifiers.sol";
import "./TokenInterface.sol";

/// @title contains all request initiations.
contract MultiSigInitiator is MultiSigModifiers {
    /// @dev initiate a request to mint tokens
    function InitiateMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
        require(
            amount > 0 && target != address(0),
            "Target address must be non-zero and amount must be greater than 0"
        );
        ClearConfirmation();
        _newSignature();
        if (IsFinalSig()) {
            _mint(target, amount);
            ClearConfirmation();
        }
        Amount = amount;
        TargetAddress = target;
        emit StartMint(target, amount);
    }

    /// @dev initiate a change of ownership of minting tokens
    function InitiateTransferOwnership(address target)
        external
        OnlyAuthorized
        ValuesCheck(address(0), 0)
    {
        require(target != address(0), "Target address must be non-zero");
        _newSignature();
        TargetAddress = target;
        emit StartChangeOwner(target);
    }

    /// @return true if there are enough votes to complete the transaction
    function IsFinalSig() internal view returns (bool) {
        return sigCounter == MinSigners;
    }

    function _newSignature() internal {
        sigCounter++;
        emit NewSig(msg.sender, sigCounter, MinSigners);
    }

    function _mint(address target, uint256 amount) internal {
        IERC20(TokenAddress).mint(target, amount);
        emit CompleteMint(target, amount);
    }

    /// @dev cancel the minting request
    function ClearConfirmation() public OnlyAuthorized {
        Amount = 0;
        TargetAddress = address(0);
        sigCounter = 0;
        emit Clear();
    }
}
