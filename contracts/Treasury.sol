// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Treasury
/// @dev A simple treasury contract controlled by the DAO
contract Treasury is Ownable {
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    constructor() Ownable(msg.sender) {}

    /// @notice Receive ETH deposits
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Deposit ETH explicitly
    function deposit() public payable {
        require(msg.value > 0, "Treasury: deposit amount must be greater than 0");
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Withdraw funds from treasury (only owner/timelock)
    /// @param recipient Address to receive the funds
    /// @param amount Amount to withdraw
    function withdrawFunds(address payable recipient, uint256 amount)
        public
        onlyOwner
    {
        require(recipient != address(0), "Treasury: invalid recipient");
        require(
            address(this).balance >= amount,
            "Treasury: insufficient balance"
        );
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Treasury: transfer failed");
        emit Withdrawal(recipient, amount);
    }

    /// @notice Get the treasury balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
