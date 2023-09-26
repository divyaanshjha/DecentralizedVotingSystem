// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VotingToken is ERC20("VoteToken", "VTO"), Ownable {
//    function mint() public onlyOwner {
//      _mint(msg.sender, 10**25);    }
    
    struct Candidate {
        string name;
        address candidateAddress;
        uint256 voteCount;
    }

    struct Voter {
        bool voteStatus;
        uint256 timestamp;
        uint256 blockHeight;
    }

    Candidate public winner;
    uint256 maxVotes = 0;

    mapping(address => Voter) public voters;
    mapping(string => Candidate) public candidates;

    string[] public listOfCandidates;


    function vote(string memory _name) public {
        require(!voters[msg.sender].voteStatus, "You have already voted");

        // Mint one ERC20 token and transfer it to the sender
        _mint(msg.sender, 1 * 10**18);

        candidates[_name].voteCount++;

        voters[msg.sender].voteStatus = true;


        voters[msg.sender].timestamp = block.timestamp;
        voters[msg.sender].blockHeight = block.number;
    }

    function addCandidate(string memory _name, address _candidateAddress) public onlyOwner {
        candidates[_name] = Candidate(_name, _candidateAddress, 0);
        listOfCandidates.push(_name);
    }

    function getVotesForCandidate(string memory _name) public view returns (uint256) {
        return candidates[_name].voteCount;
    }

    function declareWinner() public returns (string memory){
        for (uint256 i = 0; i<listOfCandidates.length; i++) 
        {
            if(candidates[listOfCandidates[i]].voteCount > maxVotes){
                maxVotes = candidates[listOfCandidates[i]].voteCount;
                winner = candidates[listOfCandidates[i]];
            }
            else{
                continue;
            }
        }
        return winner.name;
    }
    function showCandidates () public view returns (string[] memory){
        return listOfCandidates;
    }

    function voteAudit(address _voterAddress) public view returns (bool voteStatus, uint256 timestamp , uint256 blockHeight) {
        Voter memory voter = voters[_voterAddress];
        return(voter.voteStatus, voter.timestamp , voter.blockHeight);
    }
}
