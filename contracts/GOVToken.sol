// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @title GOVToken
/// @dev An ERC-20 governance token with voting delegation capabilities
contract GOVToken is ERC20, ERC20Permit, ERC20Votes {
    /// @notice Constructor initializes the token with name, symbol, and initial supply
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        _mint(msg.sender, initialSupply);
    }

    /// @notice Override required by Solidity for multiple inheritance
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    /// @notice Override required by Solidity for multiple inheritance
    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    /// @notice Override required by Solidity for multiple inheritance
    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
