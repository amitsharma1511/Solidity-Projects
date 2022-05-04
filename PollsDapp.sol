// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract PollDapp {
    // Public variables auto-genrate getter fucntions
    string public question = "Which is the best blockchain in the world ?";
    string[] public options = ["Ethereum","Bitcoin", "Solana", "none of these" ];
    mapping (uint256 => uint256) public voteCount;
    mapping (address => uint256) userVoteCount; 

    function getOptions() public view returns (string[] memory) {
        return options;             // Returns entire array
    }

    function castVote(uint256 _index) public {
        require(userVoteCount[msg.sender] == 0);     // Only one vote per account
        voteCount[_index]++;
        userVoteCount[msg.sender]++;    
    }
}