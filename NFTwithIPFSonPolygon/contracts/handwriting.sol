//SPDX-License-Identifier: MIT;

pragma solidity ^0.8.4;

import "./ERC721.sol";

contract HandwritingCollection is ERC721{

    string public name; //ERC721Metadata

    string public symbol; //ERC721Metadata

    uint256 public tokenCount;
 
    mapping (uint256 => string) private _tokenURIs;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function tokenURI(uint256 _tokenId) public view returns(string memory) { //ERC721Metadata
        require(_owners[_tokenId] != address(0), "Token id does not exist");
        return _tokenURIs[_tokenId];
    }

    function mint(string memory _tokenURI) public {
        
        tokenCount += 1;
        _balances[msg.sender] += 1;
        _owners[tokenCount] = msg.sender;
        _tokenURIs[tokenCount] = _tokenURI;

        emit Transfer(address(0), msg.sender, tokenCount);

    }

    function supportInterface(bytes4 interfaceId) public pure override returns(bool) {
        return interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;
    }
}