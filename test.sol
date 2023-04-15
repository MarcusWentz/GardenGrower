// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Bank {

    mapping(address => uint256) public balanceOf;   // balances, indexed by addresses

    function deposit() public payable {
        unchecked{ balanceOf[msg.sender] += msg.value; } //User would need uint256 Ether to overflow. Therefore, unchecked to 
    }

    function withdraw(uint256 amount) public {
        balanceOf[msg.sender] -= amount; //Will revert with type uint256 with Solidity version 0.8.0.
        payable(msg.sender).transfer(amount);
    }
}
