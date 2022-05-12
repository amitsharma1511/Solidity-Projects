const hre = require("hardhat");

async function main() {
    // Get the contract to deploy
    const BuyMeCupOfCoffee = await hre.ethers.getContractFactory("BuyMeCupOfCoffee")
    const buyMeCupOfCoffee = await BuyMeCupOfCoffee.deploy();

    // Deploy contract
    await buyMeCupOfCoffee.deployed();
    console.log("BuyMeCupOfCoffee deployed to: ", buyMeCupOfCoffee.address);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });