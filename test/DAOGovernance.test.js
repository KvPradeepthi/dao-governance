const { expect } = require("chai");
const hre = require("hardhat");
const { ethers } = hre;

describe("DAO Governance", function () {
  let govToken, daoTimelock, daoGovernor, treasury;
  let deployer, addr1;

  beforeEach(async function () {
    [deployer, addr1] = await ethers.getSigners();

    const GOVToken = await ethers.getContractFactory("GOVToken");
    govToken = await GOVToken.deploy("GOV", "GOV", ethers.parseEther("1000000"));
    await govToken.delegate(deployer.address);

    const DAOTimelock = await ethers.getContractFactory("DAOTimelock");
    daoTimelock = await DAOTimelock.deploy(2 * 24 * 60 * 60, [], [ethers.ZeroAddress], deployer.address);

    const DAOGovernor = await ethers.getContractFactory("DAOGovernor");
    daoGovernor = await DAOGovernor.deploy("Governor", await govToken.getAddress(), await daoTimelock.getAddress());

    const Treasury = await ethers.getContractFactory("Treasury");
    treasury = await Treasury.deploy();
    await treasury.transferOwnership(await daoTimelock.getAddress());
  });

  it("Should deploy successfully", async function () {
    expect(await govToken.totalSupply()).to.equal(ethers.parseEther("1000000"));
    expect(await daoGovernor.votingPeriod()).to.equal(50400);
  });

  it("Should allow voting power delegation", async function () {
    await govToken.delegate(addr1.address);
    expect(await govToken.delegates(deployer.address)).to.equal(addr1.address);
  });

  it("Should have correct governance parameters", async function () {
    expect(await daoGovernor.votingDelay()).to.equal(1);
    expect(await daoTimelock.minDelay()).to.equal(2 * 24 * 60 * 60);
  });
});
