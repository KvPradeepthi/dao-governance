// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/TimelockController.sol";

/// @title DAOTimelock
/// @dev A Timelock controller for managing execution delays in DAO governance
contract DAOTimelock is TimelockController {
    /// @notice Constructor initializes the timelock with minimum delay and roles
    /// @param minDelay_ Minimum delay in seconds before execution
    /// @param proposers_ Array of addresses that can propose
    /// @param executors_ Array of addresses that can execute
    /// @param admin_ Admin address
    constructor(
        uint256 minDelay_,
        address[] memory proposers_,
        address[] memory executors_,
        address admin_
    ) TimelockController(minDelay_, proposers_, executors_, admin_) {}
}
