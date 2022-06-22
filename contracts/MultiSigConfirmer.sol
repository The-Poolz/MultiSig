// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSigInitiator.sol";
import "./TokenInterface.sol";

contract MultiSigConfirmer is MultiSigInitiator {
    function SetConfirmers (address[] calldata _confirmers) external OnlyConfirmer {
        require(_confirmers.length > 0, "Confirmers length must be greater than 0");
        for (uint256 i = 0; i < _confirmers.length; i++) {
            require(_confirmers[i] != address(0), "Confirm address have to be not zero");
        }
        emit ConfirmersChanged(_confirmers, ConfirmersAddresses);
        ConfirmersAddresses = _confirmers;
    }

    function ConfirmMint(address target, uint256 amount)
        public
        OnlyConfirmer
        ValuesCheck(target, amount)
    {
        IERC20(TokenAddress).mint(target, amount);
        emit CompliteMint(target, amount);
        ClearConfirmation();
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
    }

    function ClearConfirmation() public OnlyConfirmerOrInitiator {
        Amount = 0;
        TargetAddress = address(0);
        emit Clear();
    }
}
