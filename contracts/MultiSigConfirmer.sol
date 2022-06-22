// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";
import "./TokenInterface.sol";

contract MultiSigConfirmer is MultiSigInitiator {
    uint256 sigCounter;

    function ChangeAuthorizedAddress(address authorize) public OnlyAuthorized {
        require(!AuthorizedMap[authorize], "can't have same address");
        require(authorize != address(0));
        emit ConfirmerChanged(authorize, msg.sender);
        AuthorizedMap[msg.sender] = false;
        AuthorizedMap[authorize] = true;
    }

    function ConfirmMint(address target, uint256 amount)
        public
        OnlyConfirmer
        ValuesCheck(target, amount)
    {
        sigCounter++;
        emit NewSig(msg.sender, sigCounter, MinSigners);
        if (IsFinalSig()) {
            IERC20(TokenAddress).mint(target, amount);
            emit CompliteMint(target, amount);
            ClearConfirmation();
        }
    }

    function ConfirmTransferOwnership(address target)
        public
        OnlyConfirmer
        ValuesCheck(target, 0)
    {
        sigCounter++;
        emit NewSig(msg.sender, sigCounter, MinSigners);
        if (IsFinalSig()) {
            IERC20(TokenAddress).addMinter(target);
            IERC20(TokenAddress).renounceMinter();
            emit CompliteChangeOwner(target);
            ClearConfirmation();
        }
    }

    function IsFinalSig() public view returns (bool) {
        return sigCounter == MinSigners;
    }

    function ClearConfirmation() public OnlyConfirmerOrInitiator {
        Amount = 0;
        TargetAddress = address(0);
        sigCounter = 0;
        emit Clear();
    }
}
