// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Miner {

    address public owner;
    IERC20 goldCoin;
    IERC20 mineralCoin;

    //Contains the contracts mineral coin balance
    mapping(address => uint256) public walletBalance;
    uint256 public mineralToBurn;

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

    //Moves the mineral coin from user, adds to the wallet balance REQUIRES APPROVAL FROM USER
    function stake(uint256 _amount) public {
        uint256 mineralBalance = mineralCoin.balanceOf(msg.sender);
        require(mineralBalance >= _amount, "Not Enough Mineral Coins");
        //Below code will fail if contract doesn't have approval
        mineralCoin.transferFrom(msg.sender, address(this), _amount);
        walletBalance[msg.sender] += _amount;
        walletBalance[address(this)] += _amount;

    }

    //removes all mineral coins from the contract, transfers to users
    function unstakeAll() public {
        uint mineralBalance = walletBalance[msg.sender];
        mineralCoin.transfer(msg.sender, mineralBalance);
        walletBalance[msg.sender] -= mineralBalance;
        walletBalance[address(this)] -= mineralBalance;
    }

    //removes set mineral coins from the contracts, transfers to users
    function unstake(uint256 _amount) public {
        uint mineralBalance = walletBalance[msg.sender];
        require(_amount <= mineralBalance, "Dont have enough mineral Coins in your wallet");
        mineralCoin.transfer(msg.sender, _amount);
        walletBalance[msg.sender] -= _amount;
        walletBalance[address(this)] -= _amount;
    }

    //Calculated Gold (ROUNDS DOWN), transfers gold coin to user, removes the mineral coin from balance, adds mineral to burn balance
    function mineGold() public {
        uint256 calcGold = walletBalance[msg.sender] * (goldRate * 10) / 1000;
        require(calcGold > 0);
        goldCoin.transfer(msg.sender, calcGold);
        walletBalance[msg.sender] -= calcGold;
        walletBalance[address(this)] -= calcGold;

        mineralToBurn += calcGold;
    }

    //Only the owner of this contract can set the rate of gold, initial gold rate is 5%
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