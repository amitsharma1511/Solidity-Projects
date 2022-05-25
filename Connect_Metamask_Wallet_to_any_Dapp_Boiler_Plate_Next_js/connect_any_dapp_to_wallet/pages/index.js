import Head from "next/head";
import Image from "next/image";
import { useState } from "react";
import styles from '../styles/Home.module.css'
//uncomment below imports when you start interacting with your smart contract
//import { ethers } from "ethers";
//import abi from '../utils/your_Contract_ABI.json';

export default function Home() {

 // Component state
  const [currentAccount, setCurrentAccount] = useState("");


    // Wallet connection logic
  const isWalletConnected = async () => {
    try {
      const { ethereum } = window;

      const accounts = await ethereum.request({method: 'eth_accounts'})
      console.log("accounts: ", accounts);

      if (accounts.length > 0) {
        const account = accounts[0];
        console.log("wallet is connected! " + account);
      } else {
        console.log("make sure MetaMask is connected");
      }
    } catch (error) {
      console.log("error: ", error);
    }
  }

  const connectWallet = async () => {
    try {
      const {ethereum} = window;

      if (!ethereum) {
        console.log("please install MetaMask");
      }

      const accounts = await ethereum.request({
        method: 'eth_requestAccounts'
      });

      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  }


  return (
    <div>
        <Head>
            <title>Connect your wallet</title>
            <meta name="description" content="Connect Your Wallet" />
            <link rel="icon" href="/favicon.ico" />
        </Head>

        <main className={styles.main}>
            <h1 className={styles.title}>
              Connect Your Wallet
            </h1>
        {currentAccount ? (
        <div>
            <h1 className={styles.connected}>Wallet Connected</h1>
          </div>
        ) : (
          <button onClick={connectWallet}> Connect your wallet </button>
        )}
        </main>
    </div>
  )

}
