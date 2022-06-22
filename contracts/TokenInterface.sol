// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function mint(address account, uint256 amount) external;

    function addMinter(address account) external;

    function renounceMinter() external;
}