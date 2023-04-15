// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

error notOwner();

contract Bank {

    address public immutable Owner;
    uint256 public test;
    uint256 public proposalCount;
    mapping(uint256 => string) public proposalInfo;   // balances, indexed by addresses
    mapping(uint256 => uint256) public proposalExpirationDeadline;   // balances, indexed by addresses
    mapping(uint256 => mapping(address => uint256)) public amountForProposal;   // balances, indexed by addresses

    mapping(address => uint256) public balanceOf;   // balances, indexed by addresses

    constructor() {
        Owner = msg.sender;
    }

    function newProposal(string calldata goalString, uint256 proposalExpirationDeadlineUnix) public {
        proposalInfo[proposalCount] = goalString; //User would need uint256 Ether to overflow. Therefore, unchecked to 
        proposalExpirationDeadline[proposalCount] = proposalExpirationDeadlineUnix; //User would need uint256 Ether to overflow. Therefore, unchecked to 
        proposalCount++;
    }

    function depositProposal(uint256 proposalNumber) public payable {
        //REVERT IF PROPOSAL COUNT IS SMALLER THAN INPUT NUMBER
        unchecked{ amountForProposal[proposalNumber][msg.sender] += msg.value; } //User would need uint256 Ether to overflow. Therefore, unchecked to 
    }

    function withdraw(uint256 proposalNumber, uint256 amount) public {
        //REVERT IF DEADLINE IS NOT HIT
        //REVERT IF PROPOSAL MET FLAG IS TRUE
        amountForProposal[proposalNumber][msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // function ownerTest() public {
    //     if(msg.sender != Owner ) {revert notOwner(); }
    //     test = block.timestamp;
    // }

}
