// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MineralCoin is ERC20, ERC20Burnable, Ownable {

    uint256 public burnRate;

    constructor()
        ERC20("MineralCoin", "MLC")
        Ownable()
    {
        _mint(msg.sender, 1000000000000 * 10 ** decimals());
    }

    function setBurnRate(uint256 _newRate) public onlyOwner {
        burnRate = _newRate;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        address owner = _msgSender();
        uint256 calcCoins = value * (burnRate * 10) / 100000;
        _transfer(owner, to, value - calcCoins);
        _burn(msg.sender, calcCoins);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        uint256 calcCoins = value * (burnRate * 10) / 100000;
        _transfer(from, to, value - calcCoins);
        _burn(msg.sender, calcCoins);
        return true;
    }

}