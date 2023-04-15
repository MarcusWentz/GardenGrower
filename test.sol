// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Bank {

    mapping(address => uint256) public balanceOf;   // balances, indexed by addresses

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;     // adjust the account's balance
    }

    function withdraw(uint256 amount) public {
        require(amount <= balanceOf[msg.sender]);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
