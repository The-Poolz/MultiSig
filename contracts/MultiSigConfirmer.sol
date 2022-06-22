// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";
import "./TokenInterface.sol";

/// @title contains confirmation requests.
contract MultiSigConfirmer is MultiSigInitiator {
    uint256 public sigCounter; // if sigCounter == MinSigners transaction can be implemented

    /// @notice only authorized address can change himself
    function ChangeAuthorizedAddress(address authorize) external OnlyAuthorized {
        require(!AuthorizedMap[authorize], "can't have same address");
        require(authorize != address(0));
        emit AuthorizedChanged(authorize, msg.sender);
        AuthorizedMap[msg.sender] = false;
        AuthorizedMap[authorize] = true;
    }

    /// @notice collects votes to confirm mint tokens
    /// if there are enough votes, coins will be minted  
    function ConfirmMint(address target, uint256 amount)
        external
        OnlyAuthorized
        ValuesCheck(target, amount)
    {
        _newSignature();
        if (IsFinalSig()) {
            IERC20(TokenAddress).mint(target, amount);
            emit CompliteMint(target, amount);
            ClearConfirmation();
        }
    }

    /// @notice transfers the right to mint tokens
    function ConfirmTransferOwnership(address target)
        external
        OnlyAuthorized
        ValuesCheck(target, 0)
    {
        _newSignature();
        if (IsFinalSig()) {
            IERC20(TokenAddress).addMinter(target);
            IERC20(TokenAddress).renounceMinter();
            emit CompliteChangeOwner(target);
            ClearConfirmation();
        }
    }

    function _newSignature() internal {
        sigCounter++;
        emit NewSig(msg.sender, sigCounter, MinSigners);
    }

    function IsFinalSig() internal view returns (bool) {
        return sigCounter == MinSigners;
    }

    /// @notice cancel the minting request
    function ClearConfirmation() public OnlyAuthorized {
        Amount = 0;
        TargetAddress = address(0);
        sigCounter = 0;
        emit Clear();
    }
}
