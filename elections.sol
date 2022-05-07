// SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

pragma solidity ^0.8.2;

contract Election is Ownable {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    enum ELECTION_STATUS{
        START,
        END
    }

    ELECTION_STATUS public electionStatus;

    // Set owner (Election commission officer)
    constructor() {
        _transferOwnership(_msgSender());
        electionStatus = ELECTION_STATUS.END;
    }


    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    // Start elections
    function startElection() public onlyOwner {
        require(electionStatus == ELECTION_STATUS.END, "Election are already ongoing");
        electionStatus = ELECTION_STATUS.START;
    }

    // Add candidates
    function _addCandidate (string memory _name) public onlyOwner {
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        candidatesCount++;
    }


    // No gas fee on running below function
    function viewCandidatesList() external view returns(Candidate[] memory) {
        Candidate[] memory candidateList = new Candidate[](candidatesCount);
        for (uint i = 0; i < candidatesCount; i++) {
            candidateList[i] = candidates[i];
        }
        return candidateList;                   // Currently it returns the accumulated vote count of candidates as well, need to fix. Should reutn only id and name.
    }


    function vote (uint _candidateId) public {
       
        
        //require elections have started
        require(electionStatus == ELECTION_STATUS.START, "Elections not yet started, check later");
        
        // require that they haven't voted before
        require(voters[msg.sender] == false);

        // require a valid candidate
        require(_candidateId == candidates[_candidateId].id);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }

    function endElections() public onlyOwner {
        require(electionStatus == ELECTION_STATUS.START, "No ongoing election to end");
        electionStatus = ELECTION_STATUS.END;
    }
}
