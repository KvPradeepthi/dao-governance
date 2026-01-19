const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy GOVToken
  console.log("\nDeploying GOVToken...");
  const GOVToken = await hre.ethers.getContractFactory("GOVToken");
  const govToken = await GOVToken.deploy(
    "Governance Token",
    "GOV",
    hre.ethers.parseEther("1000000") // 1M tokens with 18 decimals
  );
  await govToken.waitForDeployment();
  const govTokenAddress = await govToken.getAddress();
  console.log("GOVToken deployed to:", govTokenAddress);

  // Delegate voting power to deployer
  console.log("\nDelegating voting power...");
  const delegateTx = await govToken.delegate(deployer.address);
  await delegateTx.wait();
  console.log("Voting power delegated to:", deployer.address);

  // Deploy DAOTimelock
  console.log("\nDeploying DAOTimelock...");
  const minDelay = 2 * 24 * 60 * 60; // 2 days in seconds
  const DAOTimelock = await hre.ethers.getContractFactory("DAOTimelock");
  const daoTimelock = await DAOTimelock.deploy(
    minDelay,
    [], // proposers (will be set to Governor)
    [hre.ethers.ZeroAddress], // executors (anyone can execute after delay)
    deployer.address // admin
  );
  await daoTimelock.waitForDeployment();
  const daoTimelockAddress = await daoTimelock.getAddress();
  console.log("DAOTimelock deployed to:", daoTimelockAddress);

  // Deploy DAOGovernor
  console.log("\nDeploying DAOGovernor...");
  const DAOGovernor = await hre.ethers.getContractFactory("DAOGovernor");
  const daoGovernor = await DAOGovernor.deploy(
    "DAO Governor",
    govTokenAddress,
    daoTimelockAddress
  );
  await daoGovernor.waitForDeployment();
  const daoGovernorAddress = await daoGovernor.getAddress();
  console.log("DAOGovernor deployed to:", daoGovernorAddress);

  // Setup roles for DAOTimelock
  console.log("\nSetting up roles for DAOTimelock...");
  const PROPOSER_ROLE = await daoTimelock.PROPOSER_ROLE();
  const EXECUTOR_ROLE = await daoTimelock.EXECUTOR_ROLE();
  const TIMELOCK_ADMIN_ROLE = await daoTimelock.DEFAULT_ADMIN_ROLE();

  // Grant proposer role to Governor
  let tx = await daoTimelock.grantRole(PROPOSER_ROLE, daoGovernorAddress);
  await tx.wait();
  console.log("Granted PROPOSER_ROLE to Governor");

  // Grant executor role to everyone (ZeroAddress)
  tx = await daoTimelock.grantRole(EXECUTOR_ROLE, hre.ethers.ZeroAddress);
  await tx.wait();
  console.log("Granted EXECUTOR_ROLE to everyone");

  // Revoke admin role from deployer to make it decentralized
  tx = await daoTimelock.revokeRole(TIMELOCK_ADMIN_ROLE, deployer.address);
  await tx.wait();
  console.log("Revoked TIMELOCK_ADMIN_ROLE from deployer (decentralized)");

  // Deploy Treasury
  console.log("\nDeploying Treasury...");
  const Treasury = await hre.ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy();
  await treasury.waitForDeployment();
  const treasuryAddress = await treasury.getAddress();
  console.log("Treasury deployed to:", treasuryAddress);

  // Transfer Treasury ownership to Timelock
  console.log("\nTransferring Treasury ownership to Timelock...");
  tx = await treasury.transferOwnership(daoTimelockAddress);
  await tx.wait();
  console.log("Treasury ownership transferred to DAOTimelock");

  // Summary
  console.log("\n=== Deployment Summary ===");
  console.log("GOVToken:", govTokenAddress);
  console.log("DAOTimelock:", daoTimelockAddress);
  console.log("DAOGovernor:", daoGovernorAddress);
  console.log("Treasury:", treasuryAddress);
  console.log("\nGovernance parameters:");
  console.log("- Voting delay: 1 block");
  console.log("- Voting period: 50400 blocks (~1 week)");
  console.log("- Proposal threshold: 1000 tokens");
  console.log("- Quorum: 4%");
  console.log("- Timelock delay: 2 days");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
