// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


/// @title A polling smart contract
/// @author Amit Sharma
/// @notice You can use this contract for conducting simple polls
/// @custom:experimantal This is an experimental contract.
contract PollDapp {
    ///@notice Public variables auto-genrate getter fucntions
    string public question = "Which is the best blockchain in the world ?";
    string[] public options = ["Ethereum","Bitcoin", "Solana", "none of these" ];
    mapping (uint256 => uint256) public voteCount;
    mapping (address => uint256) userVoteCount; 

    /// @notice Returns the array of options
    /// @dev This can be modified further to format options
    /// @return All the options for the polling question.
    function getOptions() public view returns (string[] memory) {
        return options;             // Returns entire array
    }


    /// @notice Function to caste vote, allows only one vote per account.
    /// @dev Do not modify this function.
    /// @param _index Takes the option number as input for vote
    /// @custom:now-ok
    function castVote(uint256 _index) public {
        require(userVoteCount[msg.sender] == 0, "Already voted");
        voteCount[_index]++;
        userVoteCount[msg.sender]++;    
    }

}