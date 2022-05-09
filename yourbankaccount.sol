// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract YourSmartBank {
    
    uint256 totalContractBalance;

    mapping (address => uint256) accountBalance;
    
    function getContractBalance() public view returns(uint256) {
        return totalContractBalance;
    }

    function addBalance() public payable {
        require(msg.value > 0, "Enter a valid amount");
        accountBalance[msg.sender] += msg.value;
        totalContractBalance += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return accountBalance[msg.sender];
    }

    // Avoids Re-Entrancy
    function withdraw(uint256 _amountToWithdraw) public payable {
        require(_amountToWithdraw <= getBalance(), "Insufficient balance in account");
        accountBalance[msg.sender] -= _amountToWithdraw;
        totalContractBalance -= _amountToWithdraw;
        payable(msg.sender).transfer(_amountToWithdraw);    
    }

}