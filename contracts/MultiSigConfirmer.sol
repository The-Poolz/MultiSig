// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";
import "./TokenInterface.sol";

contract MultiSigConfirmer is MultiSigInitiator {
    function ChangeConfirmerAddress(address Confirmer) public OnlyConfirmer {
        require(Confirmer != InitiatorAddress, "can't have same address");
        require(Confirmer != address(0));
        emit ConfirmerChanged(Confirmer,ConfirmerAddress);
        ConfirmerAddress = Confirmer;

    }

    function ConfirmMint(address target, uint256 amount)
        public
        OnlyConfirmer
        ValuesCheck(target, amount)
    {
        IERC20(TokenAddress).mint(target, amount);
        emit CompliteMint(target, amount);
        ClearConfirmation();
        emit NewSig(msg.sender, target);
    }

    function ConfirmTransferOwnership(address target)
        public
        OnlyConfirmer
        ValuesCheck(target, 0)
    {
        IERC20(TokenAddress).addMiner(target);
        IERC20(TokenAddress).renounceMinter();      
        emit CompliteChangeOwner(target);
        ClearConfirmation();
        emit NewSig(msg.sender, target);
    }

    function ClearConfirmation() public OnlyConfirmerOrInitiator {
        Amount = 0;
        TargetAddress = address(0);
        emit Clear();
    }
}
