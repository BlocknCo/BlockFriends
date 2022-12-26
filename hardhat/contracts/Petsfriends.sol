// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract Petsfriends is ERC721Enumerable, ownable {

    //* @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
    //* token will be the concatenation of the 'baseURI' and the 'tokenId'.
    string _baseTokenURI;

    // _price = prix d'un pets friends de base
    uint256 public _price = 0.01 ether;

    // _paused pour mettre en pause e ncas d'urgence
    bool public _paused;

    // max de petsfriends
    uint256 public maxTokenIds = 20;

    // Nombre de token mintés
    uint256 public tokenIds;

    // Contract de la Whitelist 
    IWhitelist whitelist;

    // boolean pour savoir si la presale est commencée ou non
    bool public presaleStarted;

    // timestamp pour quand la presale sera terminée
    uint256 public presaleEnded;

    //Structure pets pour les infos de l'animal
    struct Pets {
        string name;
        string race;
        uint256 birthdate;
        string father;
        string mother;
        uint256 petid;
    }

    // structure pour le maitre de l'animal
    struct petOwner {
        address pet_owner;
        //on laisse l'addresse ? A débattre
        string owner_add;
        uint petOwnerid;
    }

    Pets[] petsArray;
    PetOwner[] petownerArray;

    event petRegistered(uint256 petId );


    modifier onlyWhenNotPaused {
        require(!_paused, "contract currently paused");
        _;
    }


    //constructeur pour mettre ne place le nom et le symbole
    //Nom = Pets friends et symbol = PF
    constructor (string memory baseURI, address whiteListContract) ERC721("Pets Friends", "PF") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whiteListContract);
    } 

    //fonction pour démarrer la presale
    //n'est déclenchable que par le owner
    //la presale prends fin 5 min après sont départ, possibilité de changer le temps pour en laisser
    //aux personnes le temps qu'elles rentrent les infos de leur animal de compagnie
    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 15 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        // voir si on garde ce require car le but étant de mettre un NFT par animal
        // voir aussi pour vérifier que l'animal ne peut être mis qu'une seule fois
        require(tokenIds < maxTokenIds, "Exceeded maximum Pets Friends supply");
        require(msg.value >= _price, "Ether sent is not correct");
        _safeMint(msg.sender, tokenIds);
    }   

    function _baseURI() internal view virtual override returns (string memory){
        return _baseTokenURI;
    }

    //mise en pause ou non du contrat par le owner
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    //retrait de la totalité des fonds pour l'envoyer sur le Owner
    function withdraw() public onlyOwner {
        address_owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "failed to send Ether");
    }


    //fonction pour rentrer les informations de l'animal et faire le lien avec son propriétaire
    function setPet(string memory _name, string _race, uint256 _birthdate, string _father, string _mother, uint256 _petId) external {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        Pets memory pets;
        pets.name = _name;
        pets.race = _race;
        pets.birthdate = _birthdate;
        pets.father = _father;
        pets.mother = _mother;
        pets.petid = _petId;
        petsArray.push(pets);

        petOwner memory petOwner;
        petOwner.petOwnerid = _petId;
        petOwner.petOwnerid = (msg.sender);
        petownerArray.push(petOwner);

        emit petRegistered(petId);
    }

    receive() external payable {}

    fallback() external payable {}

}