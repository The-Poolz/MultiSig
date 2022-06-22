// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";
import "./TokenInterface.sol";

contract MultiSigConfirmer is MultiSigInitiator {
    uint256 sigCounter;

    function ChangeConfirmerAddress(address Confirmer) public OnlyConfirmer {
        require(Confirmer != InitiatorAddress, "can't have same address");
        require(Confirmer != address(0));
        emit ConfirmerChanged(Confirmer, ConfirmerAddress);
        ConfirmerAddress = Confirmer;
    }

    function ConfirmMint(address target, uint256 amount)
        public
        OnlyConfirmer
        ValuesCheck(target, amount)
    {
        sigCounter++;
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
