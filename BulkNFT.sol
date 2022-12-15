// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RWSCT is ERC721 {

    // Address of the owner
    address public owner;
    // Number of minted tokens
    uint256 public _mintedTokens = 0;
    // base URI for metadata
    string public baseURI;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event batchMinted(uint256 _count, address _recipient);

    /**
    * @dev Constructor to assign owner and baseURI
    * @param _baseURI Link to metadata
     */
    constructor(string memory _baseURI) ERC721("Non Fungible Token", "NFT") {
        owner = msg.sender;
        baseURI=_baseURI;
    }

    /**
    * @dev Called from ERC721 standard contract to get baseURL
    * @return baseURI of metadata initialized
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
    * @dev Called by the owner to bulk mint NFTs
    * @param count Number of NFTs to be minted
    * @param _recipient Address to which the Bulk NFTs to be minted
     */
    function bulkMint(uint256 _count, address _recipient) public onlyOwner {
        uint256 _upperLimit = _mintedTokens + _count;
        for (uint256 i = _mintedTokens; i < _upperLimit; i++) {
            _mint(_recipient, i);
            _mintedTokens++;
        }
        emit batchMinted( _count, _recipient);
    }
}