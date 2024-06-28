// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bank {
    //state variable
    address public immutable owner;
    //event
    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);
    //receive
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
     }
    //constructor function
    constructor() payable {
        owner = msg.sender;
    }
    //method
    function withdraw() external {
        require(msg.sender == owner, "Not Owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}