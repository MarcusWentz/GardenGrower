// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

error notOwner();
error proposalMet();
error proposalNotExpired();
error proposalDoesNotExist();

contract GardenGrower {

    address public immutable Owner;//User would need uint256 Ether to overflow. Therefore, unchecked to 
    uint256 public proposalCount;
   
    mapping(uint256 => address) public proposalCreator;   // balances, indexed by addresses
    mapping(uint256 => string) public proposalInfo;   // balances, indexed by addresses
    mapping(uint256 => uint256) public proposalExpirationDeadline;   // balances, indexed by addresses
      
    mapping(uint256 => uint256) public totalAmountForProposal;   // balances, indexed by addresses
    mapping(uint256 => mapping(address => uint256)) public userAmountForProposal;   // balances, indexed by addresses

    mapping(uint256 => bool) public wasGoalMet;   // balances, indexed by addresses

    constructor() {
        Owner = msg.sender;
    }

    function proposerCreateProposal(string calldata goalString, uint256 proposalExpirationDeadlineUnix) public {
        proposalCreator[proposalCount] = msg.sender; //User would need uint256 Ether to overflow. Therefore, unchecked to 
        proposalInfo[proposalCount] = goalString; //User would need uint256 Ether to overflow. Therefore, unchecked to 
        proposalExpirationDeadline[proposalCount] = proposalExpirationDeadlineUnix; //User would need uint256 Ether to overflow. Therefore, unchecked to 
        proposalCount++;
    }

    function sponsorDepositProposal(uint256 proposalNumber) public payable {
        if(proposalNumber < proposalCount) { revert proposalDoesNotExist();}
        if(wasGoalMet[proposalNumber] == true ) { revert proposalMet();} 
        unchecked{ //User would need uint256 Ether to overflow. Therefore, unchecked to save gas.
            totalAmountForProposal[proposalNumber] += msg.value; 
            userAmountForProposal[proposalNumber][msg.sender] += msg.value; 
        } 
    }

    function sponsorWithdrawlAfterUnlock(uint256 proposalNumber, uint256 amount) public {
        if( block.timestamp < proposalExpirationDeadline[proposalNumber] ) {revert proposalNotExpired(); }
        if( wasGoalMet[proposalNumber] == true ) { revert proposalMet();} 
        userAmountForProposal[proposalNumber][msg.sender] -= amount;
        unchecked {
            totalAmountForProposal[proposalNumber] -= amount; // Cannot underflow because a user's balance will never be larger than the total supply. (Solmate)
        }
        payable(msg.sender).transfer(amount); //Transfer funds out the end for users to prevent recursion and reentrancy attacks.
    }

    function ownerRewardProposalComplete(uint256 proposalNumber) public {
        if( msg.sender != Owner ) {revert notOwner(); }
        if( wasGoalMet[proposalNumber] == true ) { revert proposalMet();} 
        wasGoalMet[proposalNumber] = true;
        payable(proposalCreator[proposalNumber]).transfer(totalAmountForProposal[proposalNumber]);
    }

}
