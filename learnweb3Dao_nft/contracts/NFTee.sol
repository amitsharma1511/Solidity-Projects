// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// Importing openzeppelin contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// GameItem is  ERC721 signifies that the contract we are creating imports ERC721 and follows ERC721 contract from openzeppelin
contract GameItem is ERC721 {

    constructor() ERC721("GameItem", "ITM") {
        //Mint an NFT to yourself
        _mint(msg.sender, 1);
    }

}
