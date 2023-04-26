pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTDisbursement {
    IERC721 public nft;
    uint256 public totalTokens;

    // Mapping to store rewards for each address
    mapping(address => uint256) public rewards;

    constructor(address nftAddress) {
        nft = IERC721(nftAddress);
    }

    // Updates the totalTokens state variable with the current total supply of NFTs
    function updateTokenCount() public {
        totalTokens = nft.totalSupply();
    }

    function disburseFunds() external {
        // Update totalTokens before calculating rewards
        updateTokenCount();
        require(totalTokens > 0, "No tokens minted yet");

        // Calculate the rewards based on the contract's balance
        uint256 contractBalance = address(this).balance;
        uint256 amountPerToken = contractBalance / totalTokens;

        // Loop through all tokens and update rewards for their holders
        for (uint256 i = 0; i < totalTokens; i++) {
            address tokenHolder = nft.ownerOf(i);
            rewards[tokenHolder] += amountPerToken;
        }
    }

    // Allows users to claim their rewards
    function claimRewards() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");
        // Set the sender's rewards to 0 before transferring
        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }
}