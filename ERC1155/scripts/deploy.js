// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Get the contract to deploy
  const MyNFT = await hre.ethers.getContractFactory("MyNFT")
  const myNFT = await MyNFT.deploy("MyNFT", "NFT");

  // Deploy contract
  await myNFT.deployed();
  console.log("MyNFT deployed to: ", myNFT.address);

  await myNFT.mint(50,"https://ipfs.io/ipfs/Qmdt2hkpRxiKbKREvvbuomcMK6XCJz3rD4kLGkeSLur2Rn");

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
