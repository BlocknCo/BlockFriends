// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract Petsfriends is ERC721Enumerable, ownable {
    //* @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
    //* token will be the concatenation of the 'baseURI' and the 'tokenId'.

    string _baseTokenURI;

    // _price is the price of one Crypto Dev NFT
    uint256 public _price = 0.01 ether;

    // _paused is used to pause the contract in case of an emergency
    bool public _paused;

    // max number of CryptoDevs
    uint256 public maxTokenIds = 20;

    // total number of tokenIds minted
    uint256 public tokenIds;

    // Whitelist contract instance
    IWhitelist whitelist;

    // boolean to keep track of wether presale started or not
    bool public presaleStarted;

    // timestamp for when presale would end
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "contract currently paused");
        _;
    }

    //rajout d'event de Mint, à voir avec le contrat 721

/**Dans le NFT

- Photo de l’animal
    - possibilité de l’update par la suite
- Nom*
- Race*
- Date de naissance*
- Propriétaire*
- Provenance*
- Ancien propriétaire (hash du précédent NFT)
- Vaccins
- Parents :
    - père*
    - mère*
- Numéro de puce*
- Tatouage*
- vétérinaire
- Traitements
    */
}