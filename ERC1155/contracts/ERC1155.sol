// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract ERC1155 {

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 tokenId, uint256 amount);

    event TransferBatch(address operator, address from, address to, uint256[] tokenIds, uint256[] amounts);

    // Mapping from token id to account balances
    mapping(uint256 => mapping(address => uint256)) internal _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Gets the balance of an accounts tokens
    function balanceOf(address account, uint256 tokenId) public view returns(uint256){
        require(account != address(0), "Address is zero");
        return _balances[tokenId][account];
    }

    // Gets the balance of multiple accounts tokens
    function balanaceOfBatch(address[] memory accounts, uint256[] memory tokenIds) public view returns(uint256[] memory) {
        require(accounts.length == tokenIds.length, "Accounts and token ids are not the same length");
        
        uint256[] memory batchBalances = new uint256[](accounts.length);

        for(uint256 i = 0; i < accounts.length; i++) {
            batchBalances[i] = balanceOf(accounts[i], tokenIds[i]);
        }

        return batchBalances;

    }

    // Check if an address is an operator for another address
    function isApprovedForAll(address account, address operator) public view returns(bool) {
        return _operatorApprovals[account][operator];
    }

    // Enables or disables an operator to manage all of msg.sender assets
    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function _transfer(address from, address to, uint256 tokenId, uint256 amount) private {
        uint256 fromBalance = _balances[tokenId][from];
        require(fromBalance >= amount, "Insufficient Balance");
        _balances[tokenId][from] = fromBalance - amount;
        _balances[tokenId][to] += amount;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount) public virtual {
        require(from == msg.sender || isApprovedForAll(from, msg.sender), "msg.sender is not the owner or is approved as an operator");
        require(to != address(0), "Address is zero");
        _transfer(from, to, tokenId, amount);
        emit TransferSingle(msg.sender, from, to , tokenId, amount);

        require(_checkOnERC1155Received(), "Receiver not implemented");

    }

    function _checkOnERC1155Received() private pure returns(bool){
        // Oversimplified dummy version
        return true;
    }

    function safeBatchTransferFrom(address from, address to, uint256[] memory tokenIds, uint256[] memory amounts) public {
        require(from == msg.sender || isApprovedForAll(from, msg.sender), "msg.sender is not the owner or is approved as an operator");
        require(to != address(0), "Address is zero");
        require(tokenIds.length == amounts.length, "Token Ids and amounts are not equal");
        
        for (uint256 i = 0; i < tokenIds.length; ++i) {
            uint256 tokenId = tokenIds[i];
            uint256 amount = amounts[i];

            _transfer(from, to, tokenId, amount);
        }

        emit TransferBatch(msg.sender, from, to, tokenIds, amounts);
        require(_checkOnBatchERC1155Received(), "Receiver not implemented");
    }

    function _checkOnBatchERC1155Received() private pure returns(bool) {
        // Oversimplified dummy version
        return true;
    }

    //ERC165 compliant and tells everyone that ERC1155 function is supported
    function supportsInterface(bytes4 interfaceId) public pure virtual returns(bool) {
        return interfaceId == 0xd9b67a26;
    }
}