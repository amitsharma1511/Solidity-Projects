import './App.css';
import { useState, useEffect } from "react";
import Calendar from './components/Calendar';
import { ethers } from 'ethers';
//import detectEthereumProvider from '@metamask/detect-provider';


function App() {

 // Component state
 const [currentAccount, setCurrentAccount] = useState(null);
 const [errorMessage, setErrorMessage] = useState(null);


 const connectWallet = () => {
    if (window.ethereum) {
      window.ethereum.request({method: 'eth_requestAccounts'})
      .then(result => {
        accountChangeHandler(result[0]);
      });
    } else {
      setErrorMessage('Install Metamask');
    }
 }

 const accountChangeHandler = (newAccount) => {
    setCurrentAccount(newAccount);
 }
 
  return (
    <div className="App">
      <header className="App-header">
        <h1>Walendly</h1>
        <div id="slogan">Make appointments on web3</div>
        { currentAccount ? (
          <Calendar account={currentAccount}/>
          ) : (
            <button onClick={connectWallet}>Connect Wallet</button>
          )
        }
      </header>
    </div>
  );
}

export default App;
