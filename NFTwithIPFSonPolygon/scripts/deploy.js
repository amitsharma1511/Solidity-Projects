// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Get the contract to deploy
  const HandwritingCollection = await hre.ethers.getContractFactory("HandwritingCollection")
  const handwritingCollection = await HandwritingCollection.deploy("HandwritingCollection", "HRC");

  // Deploy contract
  await handwritingCollection.deployed();
  console.log("HandwritingCollection deployed to: ", handwritingCollection.address);

  await handwritingCollection.mint("https://ipfs.io/ipfs/QmVAeeK3zwuvexDgbK6fvZRiBuJdkMH69a4R8W3Noskf1y");

  console.log("NFT successfully minted");
}



// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
