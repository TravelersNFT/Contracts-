function transfer(address to, uint256 tokenId) public override {
    address from = ownerOf(tokenId);
    require(to != address(0), "ERC721: transfer to the zero address");
    require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
    require(from == msg.sender || isApprovedForAll(from, msg.sender), "ERC721: transfer caller is not owner nor approved");

    // Calculate royalty amount
    uint256 royaltyAmount = (msg.value * 5) / 100;

    // Send royalty to ERC2981 contract
    require(address(this).balance >= royaltyAmount, "ERC721: insufficient balance");
    (bool sent, ) = address(erc2981Contract).call{value: royaltyAmount}("");
    require(sent, "ERC721: failed to send royalty");

    // Transfer token
    _transfer(from, to, tokenId);
}