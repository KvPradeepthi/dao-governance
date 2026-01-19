// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title DAOGovernor
/// @dev Governor contract for DAO governance with voting and timelock execution
contract DAOGovernor is 
    Governor,
    GovernorSettings,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl,
    Ownable
{
    bool public paused;

    event PauseToggled(bool newPauseState);
    event OffchainVoteResultSubmitted(uint256 indexed proposalId, bool passed);

    constructor(
        string memory name_,
        IVotes _token,
        TimelockController _timelock
    )
        Governor(name_)
        GovernorSettings(
            1,    // voting delay in blocks
            50400, // voting period (about 1 week on Ethereum)
            1000e18 // proposal threshold (1000 tokens with 18 decimals)
        )
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4) // 4% quorum
        GovernorTimelockControl(_timelock)
        Ownable(msg.sender)
    {
        paused = false;
    }

    // The following functions are overrides required by Solidity

    function votingDelay()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function quorumNumerator()
        public
        view
        override(GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorumNumerator();
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function proposalNeedsQueuing(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _queueOperations(
        uint256 proposalId,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._queueOperations(proposalId, calldatas, descriptionHash);
    }

    function _executeOperations(
        uint256 proposalId,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._executeOperations(proposalId, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    // Emergency pause functionality
    function togglePause() external onlyOwner {
        paused = !paused;
        emit PauseToggled(paused);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor) returns (uint256) {
        require(!paused, "Governor: proposals are paused");
        return super.propose(targets, values, calldatas, description);
    }

    // Simulate off-chain vote result attestation
    function submitOffchainVoteResult(uint256 proposalId, bool passed)
        external
        onlyOwner
    {
        require(
            state(proposalId) == ProposalState.Pending,
            "Governor: proposal not pending"
        );
        emit OffchainVoteResultSubmitted(proposalId, passed);
    }
}
