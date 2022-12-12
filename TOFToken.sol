// Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract TOFToken is ERC721URIStorage {

    address public author;

      /**
         * @dev Constructor function assigns the author
     */

    constructor()  ERC721("Real World Smart Contract Token", "RWSCT") {
        author = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == author, "Unauthorised Access"); 
        _;                              
    }

        /**
        * @dev function that mints TOF token
        * @param recipient The address of the receipient
        * @param tokenURI The URI of the token
        * @param tokenId The ID of the token
        */

    function mintNFT(address recipient, string memory tokenURI, uint256 tokenId) public onlyOwner {
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

       /**
        * @dev function that sets URI TOF token
        * @param tokenURI The URI of the token
        * @param tokenId The ID of the token
        */

    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: update caller is not owner nor approved"
        );
        _setTokenURI(tokenId, tokenURI);
    }

       /**
        * @dev function that transfers TOF token
        * @param from The address of the payee
        * @param to The address of the receipient
        * @param tokenId The ID of the token
        */

    function transferNFT(address from, address to, uint256 tokenId) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _transfer(from, to, tokenId);
    }

    /**
         * @dev function returns solidity selector to confirm token transfer
           @return bytes4- solidity selector
      */

    function onERC721Received( ) public pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
