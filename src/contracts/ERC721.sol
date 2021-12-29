// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import './libraries/Counters.sol';

/*

building out the minting function:
    a. nft to point to an address
    b. keep track of the token ids
    c. keep track of token owner addresses to token ids
    d. keep track of how many tokens an owner address has
    e. create an event that emits a transfer log - contract address,
     where it is being minted to, the id

*/

contract ERC721 is ERC165, IERC721 {

    //to access a library data or functions -
    // <library name>.<struct name>
    //<library name>.<function name>
    //Counters.Counter

    //using SafeMath library for uint256
    //to access - <data variable>.<library function>
    using SafeMath for uint256;
    //using Counters library for Counter struct
    //to access - <data variable>.<library function>
    using Counters for Counters.Counter;
    // mapping in solidity creates a hash table of key pair values

    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens 
    mapping(address => Counters.Counter) private _OwnedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;


    // EXERCISE: 1. REGISTER THE INTERFACE FOR THE ERC721 contract so that it includes
    // the following functions: balanceOf, ownerOf, transferFrom
    // *note by register the interface: write the constructors with the 
    // according byte conversions

    // 2.REGISTER THE INTERFACE FOR THE ERC721Enumerable contract so that includes
    // totalSupply, tokenByIndex, tokenOfOwnerByIndex functions

    // 3.REGISTER THE INTERFACE FOR THE ERC721Metadata contract so that includes
    // name and the symbol functions


    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)') ^
        keccak256('ownerOf(bytes4)') ^ keccak256('transferFrom(bytes4)')));
    }

    //we find the current balance
    function balanceOf(address _owner) public override view returns (uint256) {
        require(_owner != address(0), 'owner query for non-existent token');
        return _OwnedTokensCount[_owner].current();
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token');
        return owner;
    }


    function _exists(uint256 tokenId) internal view returns (bool){
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId 
        address owner = _tokenOwner[tokenId];
        // return truthiness tha address is not zero
        return owner != address(0);
    }

    //this function is not safe
    //any type of mathematics can be held to dubious standards in solidity
    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero addres');
        // requires that the token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one to the count
        _OwnedTokensCount[to].increment();
        //x = x + 1
        //r = x + y
        //if x = 4 , y = 3 then r = 4 + 3 = 7
        //abs r >= x
        // r = x - y, abs y <= x


        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT 
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');

        _OwnedTokensCount[_from].decrement();
        _OwnedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);

    }

    // 1. require that the person approving is the owner
    // 2. we are approving an address to a token (tokenId)
    // 3. require that we cant approve sending tokens of the owner to the owner (current caller)
    // 4. update the map of the approval addresses

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    function getApproved(uint256 _tokenId) public view returns (address){

        return _tokenApprovals[_tokenId];
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender);
    }

}

