// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSig {
    mapping(address => bool) signed;
    address[] signers;

    bool isSigner;

    modifier IsEachSignerSignedTransaction() {
        for (uint256 i = 0; i < signers.length; i++) {
            require(signed[signers[i]], "Not each signer signed the transaction");
        }
        _;
    }

    modifier onlySigner() {
        isSigner = false;
        for (uint256 i = 0; i < signers.length; i++) {
            if (msg.sender == signers[i]) {
                isSigner = true;
            }
        }
        _;
    }

    function Sign() public onlySigner {
        require (isSigner, "msg.sender is not a valid signer");
        require (!signed[msg.sender]);
        signed[msg.sender] = true;
        isSigner = false;
    }

    function SetSigners(address[] calldata _signers) external onlySigner {
        signers = _signers;
        isSigner = false;
    }
}