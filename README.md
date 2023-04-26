# Contracts-

Solidity Smart Contracts

The "ERC721JustRoyalty.sol" is just the royalty function that can be added to an existing simple ERC721 NFT contract. It has not been tested and was created with help from chatGPT.

The "ERC721Simple.sol" is a basic ERC721 NFT contract with a whitelist function. It has been tested and works as intended.

The "ERC721Total.sol" is an ERC721 contract that combines both the Simple and JustRoyalty into an approximate final form of the contract. It has not been tested and was created with help from chatGPT.

The "IERC2981Royalty.sol" is an ERC2981 contract that's meant to work in tandem with the ERC721Total contract as the receiver and distributor of the royalties. It has not been tested and was created with help from chatGPT.

The "NftRoyaltyDistribution.sol" is a custom contract that sets aside a fraction of the contract balance for each NFT holder and then allows the holder to withdraw their share whenever. Currently the "snapshot" for setting aside the correct rewards is just triggered whenever the disburseFunds() contract is called. It has been tested with one royalty recipient and was created with help from chatGPT. For 3 minted NFTs, the transaction fee for calling disburseFunds() was .0091048 ROSE (91,048 gas used by transaction). When there were 6 minted NFTs it was .006 (66,500) ROSE but this might have been lower because the contract balance was 0. I tried with 6 minted NFTs again but with .1 ROSE contract balance (just like with the 3 minted NFTs case) and it was .00864 ROSE (86400 gas used by transaction).
