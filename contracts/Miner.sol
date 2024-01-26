// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Miner {

    address public owner;
    IERC20 goldCoin;
    IERC20 mineralCoin;

    mapping(address => uint256) public walletBalance;

    uint8 public goldRate = 5;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(IERC20 _mineralCoin, IERC20 _goldCoin) {
        owner = msg.sender;
        goldCoin = _goldCoin;
        mineralCoin = _mineralCoin;
    }

    function stake(uint256 _amount) public {
        uint256 mineralBalance = mineralCoin.balanceOf(msg.sender);
        require(mineralBalance >= _amount, "Not Enough Mineral Coins");
        mineralCoin.transferFrom(msg.sender, address(this), _amount);
        walletBalance[msg.sender] += _amount;

    }

    function unstakeAll() public {
        uint mineralBalance = walletBalance[msg.sender];
        mineralCoin.transfer(msg.sender, mineralBalance);
        walletBalance[msg.sender] -= mineralBalance;
    }

    function unstake(uint256 _amount) public {
        uint mineralBalance = walletBalance[msg.sender];
        require(_amount <= mineralBalance, "Dont have enough mineral Coins in your wallet");
        mineralCoin.transfer(msg.sender, _amount);
        walletBalance[msg.sender] -= _amount;
    }

    function mineGold() public {
        uint256 calcGold = walletBalance[msg.sender] * (goldRate * 10) / 1000;
        goldCoin.transfer(msg.sender, calcGold);
        walletBalance[msg.sender] -= calcGold;
        //IAddERC20(mineralCoin).burn(walletBalance[msg.sender]);
       //mineralCoin.burnFrom(address(this), walletBalance[msg.sender]);

    }

    function setGoldRate(uint8 _newRate) public onlyOwner {
        goldRate = _newRate;
    }

    function getGoldBalance() public view returns(uint256) {
        return goldCoin.balanceOf(address(this));
    }

    function getMineralBalance() public view returns(uint256) {
        return mineralCoin.balanceOf(address(this));
    }

}