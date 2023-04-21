// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract MyNFT is ERC721Enumerable, IERC2981 {
    address private _royaltyReceiver;
    uint256 private _royaltyFee = 5;
    uint256 private _lastDistributionTime;

    mapping(uint256 => uint256) private _tokenRoyaltyAmount;

    constructor(
        string memory name,
        string memory symbol,
        address royaltyReceiver,
        uint256 royaltyFee
    ) ERC721(name, symbol) {
        _royaltyReceiver = royaltyReceiver;
        _royaltyFee = royaltyFee;
        _lastDistributionTime = block.timestamp;
    }

    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        receiver = _royaltyReceiver;
        royaltyAmount = (salePrice * _royaltyFee) / 100;
    }

    function distributeRoyalties() external {
        require(block.timestamp >= _lastDistributionTime + 30 days, "Royalty distribution not yet due");

        uint256 totalSupply = totalSupply();
        for (uint256 i = 0; i < totalSupply; i++) {
            uint256 token = tokenByIndex(i);
            address[] memory holders = getHolders(token);
            uint256 royaltyAmount = _tokenRoyaltyAmount[token];
            uint256 numHolders = holders.length;
            uint256 amountPerHolder = royaltyAmount / numHolders;

            for (uint256 j = 0; j < numHolders; j++) {
                payable(holders[j]).transfer(amountPerHolder);
            }
        }

        _lastDistributionTime = block.timestamp;
    }

    function getHolders(uint256 tokenId) public view returns (address[] memory) {
    address owner = ownerOf(tokenId);
    uint256 balance = balanceOf(owner);
    address[] memory holders = new address[](balance);

    for (uint256 i = 0; i < balance; i++) {
        holders[i] = owner;
    }

    return holders;
    }
}
