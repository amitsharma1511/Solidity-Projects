// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract YourSmartBank {

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    event AddBalance(address indexed fromAddress, uint256 amountDeposited);
    event WithdrawAmount(address indexed toAddress, uint256 amountWithdrawn);

    receive() external payable { }

    mapping (address => uint256) accountBalance;
    
    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function addBalance() public payable {
        require(msg.value > 0, "Enter a valid amount");
        accountBalance[msg.sender] += msg.value;
        emit AddBalance(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint256) {
        return accountBalance[msg.sender];
    }

    // Avoids Re-Entrancy
    function withdraw(uint256 _amountToWithdraw) public nonReentrant {

        if (_amountToWithdraw <= getBalance()) {
            accountBalance[msg.sender] -= _amountToWithdraw;
        }
        
        payable(msg.sender).transfer(_amountToWithdraw);
        emit WithdrawAmount(msg.sender, _amountToWithdraw);
    }

    fallback() external payable { }

}