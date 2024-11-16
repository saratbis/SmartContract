// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract STKToken is ERC20, Ownable, ERC20Burnable {
    uint256 public cashback = 10;
    uint256 public burn = 1;
    // define name and symbol of token
    constructor(uint256 initialToken) ERC20("STKToken", "STK") Ownable(msg.sender) {
        _mint(msg.sender, initialToken * 10**decimals());
    }

    function mint(address addressDest, uint256 totNewToken) public onlyOwner {
        _mint(addressDest, totNewToken);
    }
   
   // buy a product with STK and get a cashback
    function makePurchase(address buyer, uint256 Value) public {
        //check for availability token by buyer
        require(balanceOf(buyer) >= Value, "Token not available");

        uint256 cashbackValue = (Value * cashback) / 100;
        uint256 burnValue = (Value * burn) / 100;

        // totToken for seller
        uint256 transfer = Value-cashbackValue-burnValue;

        // burn Token
        if (burnValue>0) 
            _burn(buyer, burnValue);

        _transfer(buyer, msg.sender, transfer);

       // cashback for buyer
        if (cashbackValue > 0)
            _mint(buyer, cashbackValue);
    }

    // updated cashback value
    function setCashbackPercentage(uint256 newCashbackPercentage) external onlyOwner {
        cashback = newCashbackPercentage;
    }

   // updated burn value
    function setBurnPercentage(uint256 newBurnPercentage) external onlyOwner {
        burn = newBurnPercentage;
    }

    function totalTokenIncludingBurned() public view returns (uint256) {
        return totalSupply() + balanceOf(address(0));
    }
}