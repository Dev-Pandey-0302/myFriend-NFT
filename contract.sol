// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// Importing reliable community-reviewed smart contract components from OpenZeppelin.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/**
 * @title MyFriend-NFT
 * @dev ERC-721 NFT contract with divisible metadata URIs and integrated royalties.
 */
contract MyFriendNFT is ERC721Enumerable, Ownable, ReentrancyGuard, IERC2981 {
    using Strings for uint256;

    // Metadata URIs for different token ranges.
    string public baseURI1;
    string public baseURI2;
    string public baseURI3;
    string public baseURI4;
    string public baseURI5;
    string public baseExtension = ".json";

    // Token ranges for each metadata URI.
    uint256 public splitTokenID1 = 2000;
    uint256 public splitTokenID2 = 4000;
    uint256 public splitTokenID3 = 6000;
    uint256 public splitTokenID4 = 8000;

    // Royalty information.
    address public royaltyRecipient;
    uint256 public constant ROYALTY_PERCENT = 500; // 5% in basis points

    // Maximum number of tokens and minting limits.
    uint256 public constant MAX_SUPPLY = 9999;
    uint256 public constant MAX_MINT_AMOUNT = 50;

    /**
     * @dev Contract constructor.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI1,
        string memory _baseURI2,
        string memory _baseURI3,
        string memory _baseURI4,
        string memory _baseURI5,
        address _royaltyRecipient
    ) ERC721(_name, _symbol) {
        baseURI1 = _baseURI1;
        baseURI2 = _baseURI2;
        baseURI3 = _baseURI3;
        baseURI4 = _baseURI4;
        baseURI5 = _baseURI5;
        royaltyRecipient = _royaltyRecipient;
    }

    /**
     * @dev Returns the URI for a given token.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token ID does not exist");
        if (tokenId <= splitTokenID1) {
            return string(abi.encodePacked(baseURI1, tokenId.toString(), baseExtension));
        } else if (tokenId <= splitTokenID2) {
            return string(abi.encodePacked(baseURI2, tokenId.toString(), baseExtension));
        } else if (tokenId <= splitTokenID3) {
            return string(abi.encodePacked(baseURI3, tokenId.toString(), baseExtension));
        } else if (tokenId <= splitTokenID4) {
            return string(abi.encodePacked(baseURI4, tokenId.toString(), baseExtension));
        } else {
            return string(abi.encodePacked(baseURI5, tokenId.toString(), baseExtension));
        }
    }

    /**
     * @dev Returns the royalty information.
     */
    function royaltyInfo(uint256, uint256 salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
        return (royaltyRecipient, (salePrice * ROYALTY_PERCENT) / 10000);
    }

    /**
     * @dev Set a new royalty recipient.
     */
    function setRoyaltyRecipient(address _newRoyaltyRecipient) external onlyOwner {
        royaltyRecipient = _newRoyaltyRecipient;
    }

    /**
     * @dev Withdraw contract's  balance.
     */
    function withdraw() external onlyOwner nonReentrant {
        payable(owner()).transfer(address(this).balance);
    }

    /**
     * @dev Mint new tokens.
     */
    function mint(address _to, uint256 _mintAmount) public onlyOwner {
        uint256 supply = totalSupply();
        require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT, "Invalid mint amount");
        require(supply + _mintAmount <= MAX_SUPPLY, "Exceeds max supply");

        for (uint256 i = 0; i < _mintAmount; i++) {
            _safeMint(_to, supply + i + 1);
        }
    }

    // Update metadata URIs.
    function setBaseURI1(string memory _newBaseURI1) external onlyOwner { baseURI1 = _newBaseURI1; }
    function setBaseURI2(string memory _newBaseURI2) external onlyOwner { baseURI2 = _newBaseURI2; }
    function setBaseURI3(string memory _newBaseURI3) external onlyOwner { baseURI3 = _newBaseURI3; }
    function setBaseURI4(string memory _newBaseURI4) external onlyOwner { baseURI4 = _newBaseURI4; }
    function setBaseURI5(string memory _newBaseURI5) external onlyOwner { baseURI5 = _newBaseURI5; }
    function setBaseExtension(string memory _newBaseExtension) external onlyOwner { baseExtension = _newBaseExtension; }

    // Update token split values.
    function setSplitTokenID1(uint256 _newSplitTokenID1) external onlyOwner { splitTokenID1 = _newSplitTokenID1; }
    function setSplitTokenID2(uint256 _newSplitTokenID2) external onlyOwner { splitTokenID2 = _newSplitTokenID2; }
    function setSplitTokenID3(uint256 _newSplitTokenID3) external onlyOwner { splitTokenID3 = _newSplitTokenID3; }
    function setSplitTokenID4(uint256 _newSplitTokenID4) external onlyOwner { splitTokenID4 = _newSplitTokenID4; }
}
