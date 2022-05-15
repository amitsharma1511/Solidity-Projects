let MoodContract;
let signer;

const MoodContractAddress = "0xB3431b3B5996B977270616724aeE21ba256c1786";
const MoodContractABI = [
                            {
                            "inputs": [
                                {
                                    "internalType": "string",
                                    "name": "_mood",
                                    "type": "string"
                                }
                            ],
                            "name": "setMood",
                            "outputs": [],
                            "stateMutability": "nonpayable",
                            "type": "function"
                            },
                            {
                            "inputs": [],
                            "name": "getMood",
                            "outputs": [
                                {
                                    "internalType": "string",
                                    "name": "",
                                    "type": "string"
                                }
                            ],
                            "stateMutability": "view",
                            "type": "function"
                            }
                        ];




const provider = new ethers.providers.Web3Provider(window.ethereum, "goerli");

provider.send("eth_requestAccounts", []).then(() => {
        provider.listAccounts().then((accounts) => {
        signer = provider.getSigner(accounts[0]);
        MoodContract = new ethers.Contract(
                                    MoodContractAddress,
                                    MoodContractABI,
                                    signer
                                );
        });
});

async function getMood() {
    const getMoodPromise = MoodContract.getMood();
    const Mood = await getMoodPromise;
    console.log(Mood);
}

async function setMood() {
    const mood = document.getElementById("mood").value;
    const setMoodPromise = MoodContract.setMood(mood);
    console.log("Updated Mood");
    await setMoodPromise;
}
