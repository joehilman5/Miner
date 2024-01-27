// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GoldCoin is ERC20, ERC20Burnable, Ownable {

    constructor()
        ERC20("GoldCoin", "GCN")
        Ownable()
    {
        _mint(msg.sender, 100000000000000 * 10 ** decimals());
    }
    
    function burnGold(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }

}