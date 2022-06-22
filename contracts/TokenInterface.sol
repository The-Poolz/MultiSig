// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    /// @notice increase total supply of token 
    function mint(address account, uint256 amount) external;
    /// @notice who can increase total supply
    function addMinter(address account) external;
    /// @notice remove msg.sender address from minter role
    function renounceMinter() external;
}
