# DAO Governance Smart Contract System

A robust Decentralized Autonomous Organization (DAO) governance system with proposal, voting, and execution mechanisms on EVM-compatible blockchains.

## Project Overview

This project implements a complete DAO governance infrastructure featuring:
- **GOVToken**: ERC-20 governance token with voting delegation
- **DAOTimelock**: Timelock controller for execution delays
- **DAOGovernor**: Governor contract orchestrating proposals and voting
- **Treasury**: Smart contract for managing DAO funds

## Features

- Token-weighted voting mechanism
- Configurable voting periods and thresholds
- Quorum-based proposal requirements
- Timelock delay for secure execution
- Emergency pause functionality
- Off-chain voting integration (conceptual)
- Comprehensive unit tests (80%+ coverage)
- Docker support for easy setup

## Governance Parameters

- **Voting Delay**: 1 block
- **Voting Period**: 50,400 blocks (~1 week on Ethereum)
- **Proposal Threshold**: 1,000 GOV tokens
- **Quorum**: 4% of total voting power
- **Timelock Delay**: 2 days

## Setup Instructions

### Prerequisites
- Node.js v16 or higher
- npm or yarn
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/KvPradeepthi/dao-governance.git
cd dao-governance

# Install dependencies
npm install

# Setup environment variables
cp .env.example .env
```

### Local Deployment

```bash
# Start Hardhat local network
npm run node

# In another terminal, deploy contracts
npm run deploy:local
```

### Testnet Deployment

```bash
# Deploy to Sepolia testnet
npm run deploy:sepolia
```

## Testing

```bash
# Run all tests
npm test

# Run tests with coverage
npm run coverage
```

## Docker Setup

```bash
# Build and run with Docker
docker-compose up
```

## Contract Interactions

### Creating a Proposal

Proposals can be created by any GOV token holder with sufficient voting power.

### Voting on Proposals

Token holders can vote "for", "against", or "abstain" on active proposals.

### Queuing and Executing Proposals

Successful proposals are queued and executed after the timelock delay.

## Architecture

The system follows a modular design:
1. **GOVToken**: Manages voting power distribution
2. **DAOTimelock**: Ensures secure proposal execution
3. **DAOGovernor**: Coordinates governance operations
4. **Treasury**: Stores and manages DAO assets

## Security Considerations

- All external calls protected against reentrancy
- Role-based access control using OpenZeppelin
- Input validation on all public functions
- Emergency pause mechanism for security
- Regular security audits recommended

## Gas Optimization

- Efficient storage patterns
- Minimal loop iterations
- Optimized data structures
- Critical functions prioritized for gas efficiency

## Testing Strategy

- Unit tests for all major functions
- Integration tests for contract interactions
- Edge case testing
- 80%+ line coverage achieved

## Technologies Used

- **Solidity 0.8.20**: Smart contract language
- **Hardhat**: Development framework
- **OpenZeppelin Contracts**: Audited contract implementations
- **Ethers.js**: Web3 library
- **Docker**: Containerization

## File Structure

```
dao-governance/
├── contracts/          # Smart contracts
│   ├── GOVToken.sol
│   ├── DAOTimelock.sol
│   ├── DAOGovernor.sol
│   └── Treasury.sol
├── scripts/           # Deployment scripts
│   └── deploy.js
├── test/              # Test files
│   └── DAOGovernance.test.js
├── Dockerfile
├── docker-compose.yml
├── hardhat.config.js
├── package.json
└── README.md
```

## Deployment Summary

After deployment, you will receive contract addresses:
- GOVToken Address
- DAOTimelock Address
- DAOGovernor Address
- Treasury Address

## Future Enhancements

- UUPS proxy pattern for upgradeability
- Advanced voting mechanisms
- Multi-sig wallet integration
- Snapshot integration
- Frontend dashboard

## License

MIT

## Contributing

Contributions are welcome. Please fork the repository and submit a pull request.

## Author

KvPradeepthi
