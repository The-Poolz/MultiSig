// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";
import "./TokenInterface.sol";

contract MultiSigConfirmer is MultiSigInitiator {
    function ChangeConfirmerAddress(address Confirmer) public OnlyConfirmer {
        require(Confirmer != InitiatorAddress, "can't have same address");
        require(Confirmer != address(0));
        ConfirmerAddress = Confirmer;
    }

    function ConfirmMint(uint256 amount, address target)
        public
        OnlyConfirmer
        ValuesCheck(target, amount)
    {
        IERC20(TokenAddress).mint(target, amount);
        ClearConfirmation();
    }

    function ConfirmTransferOwnership(address target)
        public
        OnlyConfirmer
        ValuesCheck(target, 0)
    {
        IERC20(TokenAddress).addMiner(target);
        IERC20(TokenAddress).renounceMinter();
        ClearConfirmation();
    }

    function ClearConfirmation() public OnlyConfirmerOrInitiator {
        Amount = 0;
        TargetAddress = address(0);
    }
}
