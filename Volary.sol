// SPDX-License-Identifier: GPLv3
pragma solidity 0.8.4;


import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact aaraamasree@nes.tech

// This is a contract for volary token mint, pause and burn
contract Volary is ERC20Burnable, Pausable, Ownable{

    /**
   * @dev Constructor function initializes the symbol and name for the token with the amount to be minted to the deployer address.
   */ 
    constructor() ERC20("Volary", "VLRY") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    /**
    * @dev Pause function calls the _pause method from Pausable.sol to pause the contract for an instance.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
    * @dev Unpause function calls the _unpause method from Pausable.sol to unpause the contract for an instance.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
    * @dev To mint the token to any specific address with an custum amount of the number of tokens.
    * @param to The address of the wallet you want to mint the token to
    * @param amount The amount of tokens you want to mint
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
    * @dev ERC20 hook that is called before the minting and buring of the token.
    * @param from The address transfering the tokens
    * @param to The address recieving the transfer of tokens 
    * @param amount Amount of tokens to be transfered
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount); // Inheriting the params from above
    }
}
