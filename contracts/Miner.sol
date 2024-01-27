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

    //500 = 5.00%
    uint256 public goldRate = 500;

    uint256 public mineralPrice = 2 ether;

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
        uint256 calcGold = walletBalance[msg.sender] * (goldRate * 10) / 100000;
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

    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function buyMineral() public payable {
        require(msg.value >= mineralPrice, "Not Enough Money Sent");
        uint256 calcCoin = msg.value / mineralPrice;
        mineralCoin.transfer(msg.sender, calcCoin);
        //(bool sent, ) = payable(owner).call{value: msg.value}("");
        //require(sent, "Ether did not send");
    }

    function payOut() public payable onlyOwner {
        (bool sent, ) = payable(owner).call{value: getContractBalance()}("");
        require(sent, "Ether Didn't Pay Out");
    }

    receive() external payable { }

}