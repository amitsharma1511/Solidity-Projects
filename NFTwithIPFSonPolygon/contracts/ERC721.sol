//SPDX-License-Identifier: MIT;

pragma solidity ^0.8.4;

contract ERC721 {

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    event Approval(address indexed _owner, address indexed _to, uint256 tokenId);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    mapping(address => uint256) internal _balances;

    mapping(uint256 => address) internal _owners;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping(uint256 => address) private _tokenApprovals;

    // Returns the number of NFTs assigned to an owner address (Owner of NFTs)
    function balanceOf(address _owner) public view returns(uint256){
        require(_owner != address(0), "Address is zero");
        return _balances[_owner];
    }

    // Finds the owner of a NFT
    function ownerOf(uint256 _tokenId) public view returns(address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "TokenId does not exist");
        return owner;
    }

    // Enables or disables an operator to manage all of msg.sender's assets
    function setApprovalsForAll(address _operator, bool _approved) public {
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // Checks if an address is an operator for another address
    function isApprovedForAll(address _owner, address _operator) public view returns(bool){
        return _operatorApprovals[_owner][_operator];
    }

    //Updates an approved address for NFT
    //Only owner and authorized operator should invoke this function
    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Msg.sender is not the owner or an authorized operator");
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    //Gets the approved address for a single NFT
    function getApproved(uint256 _tokenId) public view returns(address) {
        require(_owners[_tokenId] != address(0), "Token id does not exist");
        return _tokenApprovals[_tokenId];
    }

    // Transfer ownership of an NFT
    function transferFrom(address from, address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(
            msg.sender == owner ||
            getApproved(tokenId) == msg.sender ||
            isApprovedForAll(owner, msg.sender), "Msg.sedner is not the owner or approved for transfer"
        );
        require(owner == from, "From address is not the owner");
        require(to != address(0), "Address is zero");
        require(_owners[tokenId] != address(0), "Token id does not exist");

        approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    // Similar to standardt transferFrom function but also checks if onERC721Received is implemeted when sending to smart contract
    // _data is arbitrary instruction that you want to send to _checkOnERC721Received
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public  {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

    // Similar to safeTransferFrom above it just doesn't have _data parameter
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }
    
    // oversimplified dummy version of _checkOnERC721Received fucntion
    function _checkOnERC721Received() private pure returns(bool) {
        return true;
    }

    // EIP165: Allows to query if a contract implements another interface
    function supportInterface(bytes4 interfaceId) public pure virtual returns(bool) {
        return interfaceId == 0x80ac58cd;
    }

}

