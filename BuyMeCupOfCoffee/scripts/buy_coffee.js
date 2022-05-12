// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// Returns the Ether balance of a given address
async function getBalance(address) {
  const balanceBigInt = await hre.waffle.provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

// Logs the ether balance for  list of addressess.
async function printBalances(addresses) {
  let idx = 0;
  for (const address of addresses) {
    console.log(`Address ${idx} balance: `, await getBalance(address));
    idx++;
  }
}

// Logs the memos stored on-chain from coffee purchases.
async function printMemos(memos) {
  for (const memo of memos) {
    const timestamp = memo.timestamp;
    const tipper = memo.name;
    const tipperAddress = memo.from;
    const message = memo.message;
    console.log(`At ${timestamp} ${tipper}  (${tipperAddress}) said: "${message}"`);
  }
}

async function main() {
  // Get example acccounts
  const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners(); 

  // Get the contract to deploy
  const BuyMeCupOfCoffee = await hre.ethers.getContractFactory("BuyMeCupOfCoffee")
  const buyMeCupOfCoffee = await BuyMeCupOfCoffee.deploy();

  // Deploy contract
  await buyMeCupOfCoffee.deployed();
  console.log("BuyMeCupOfCoffee deployed to: ", buyMeCupOfCoffee.address);

  // Check balance before coffee purchase
  const addresses = [owner.address, tipper.address, tipper2.address, tipper3.address, buyMeCupOfCoffee.address];
  console.log("=== START ===");
  await printBalances(addresses);
  
  // Buy the owner a few coffee
  const tip = {value: hre.ethers.utils.parseEther(amount)};
  await buyMeCupOfCoffee.connect(tipper).buyCoffee("Aman", "Waah yaar", tip);
  await buyMeCupOfCoffee.connect(tipper2).buyCoffee("Komal", "You're the best!", tip);
  await buyMeCupOfCoffee.connect(tipper3).buyCoffee("Chris", "We are all together on this journey", tip);

  // Check balances after coffee purchase
  console.log("=== Bought Coffee ===");
  await printBalances(addresses);

  // withdraw funds
  await buyMeCupOfCoffee.connect(owner).withdrawTips();

  // check balance after withdraw
  console.log("=== Withdraw Tips ===");
  await printBalances(addresses);

  // Read all memos left for the owner
  console.log("=== Memos ===");
  const memos = await buyMeCupOfCoffee.getMemos();
  printMemos(memos);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
