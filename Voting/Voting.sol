// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract voting{
    
    address public electionCommissionar;
    uint public totalVoter;
    uint public totalCandidate;
    
    struct voter {
        bool selected;
        bool voted;
        address vote;
    }
    
    struct candidate {
        string name;
        string party;
        uint numVotes;
        bool selected;
    }
    
    mapping(address => voter) public voters;
    mapping(address => candidate) public candidates;
    address[] candidateList; 
    
    constructor() {
        electionCommissionar = msg.sender;
        voters[electionCommissionar].selected = true;
    }
    
    function getCommissionar() public view returns(address){
        return electionCommissionar;
    }
    
    function getVoter()public view returns(bool, bool, address){
        return (voters[msg.sender].selected, voters[msg.sender].voted, voters[msg.sender].vote);
    }
    
    function addCandidate(address candidateAddress, string memory name, string memory party)public returns(bool){
        require(msg.sender == electionCommissionar, "Only commissionar can add candidate.");
        
       if(candidates[candidateAddress].selected){
            return false;
       }
        
        candidates[candidateAddress].selected = true;
        candidates[candidateAddress].name = name;
        candidates[candidateAddress].party = party;
        candidateList.push(candidateAddress);
        totalCandidate++;
        return true;
        
    }
    
    function addVoter(address voterAddress) public returns(bool) {
        require(msg.sender == electionCommissionar, "Only commissionar can add voter.");
        
        if(voters[voterAddress].selected){
            return false;
        }
        
        voters[voterAddress].selected = true;
        totalCandidate++;
        return true;
    }
    
    function vote(address candidateAddress) public {
        require(voters[msg.sender].selected==true, "Only a voter can vote.");
        require(candidates[candidateAddress].selected==true, "Not a valid candidate.");
        require(voters[msg.sender].voted==false, "Voter already voted.");
        
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = candidateAddress;
        candidates[candidateAddress].numVotes +=1;
        
    }
    
    function getWinner() public view returns(string memory, string memory, uint) {
        uint maxVote = 0;
        uint index = 0;
        
        for(uint i = 0; i< candidateList.length; i++){
            if(candidates[candidateList[i]].numVotes > maxVote){
                maxVote = candidates[candidateList[i]].numVotes;
                index = i;
            }
        }
        
        return (candidates[candidateList[index]].name, candidates[candidateList[index]].party, candidates[candidateList[index]].numVotes);
        
    }
    
    
}