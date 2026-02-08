const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with account:", deployer.address);
  console.log(
    "Account balance:",
    (await deployer.provider.getBalance(deployer.address)).toString()
  );

  // Deploy SupportToken
  const SupportToken = await hre.ethers.getContractFactory("SupportToken");
  const token = await SupportToken.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log("SupportToken deployed to:", tokenAddress);

  // Deploy StartupBooster
  const StartupBooster = await hre.ethers.getContractFactory("StartupBooster");
  const booster = await StartupBooster.deploy(tokenAddress);
  await booster.waitForDeployment();
  const boosterAddress = await booster.getAddress();
  console.log("StartupBooster deployed to:", boosterAddress);

  // Give mint permission
  const tx = await token.setMinter(boosterAddress, true);
  await tx.wait();
  console.log("StartupBooster set as minter");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
