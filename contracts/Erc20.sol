// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";
contract AToken is ERC20 {
    address public owner;
    uint256 constant public AAVE_PRICE_USD = 88.53 * (10 ** 18); 
    uint256 constant public MTC_PRICE_USD = 1.72 * (10 ** 18); 

    uint256 public mtcToUsd;
    uint256 public aaveToUsd;
    constructor() ERC20("aToken Ethereum", "AToken") {
        owner = msg.sender;
        mtcToUsd =  MTC_PRICE_USD; 
        aaveToUsd = AAVE_PRICE_USD; 
    }

    function mintTokenswithMTC(address recipient, uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint tokens");
        uint256 aaveAmount1 = (amount * mtcToUsd) * (10**15)/ aaveToUsd;
        _mint(recipient, aaveAmount1);
        console.log(balanceOf(recipient));
        console.log(aaveAmount1);
        console.log(mtcToUsd);
        console.log(aaveToUsd);
        uint256 balanceAfterMint = balanceOf(recipient);
        emit BalanceAfterMint(recipient, balanceAfterMint);
        emit TokensMinted(recipient, amount, aaveAmount1);
    }

    function mintTokensWithUSD(address recipient, uint256 usdAmount) external {
        require(msg.sender == owner, "Only owner can mint tokens");
        uint256 aaveAmount2 = usdAmount * (10**15) / aaveToUsd;
        _mint(recipient, aaveAmount2);
        console.log(balanceOf(recipient));
        console.log(aaveToUsd);

        emit TokensMinted(recipient, usdAmount, aaveAmount2);
    }

    event BalanceAfterMint(address indexed recipient, uint256 balance);

    function burnTokenswithMTC(address recipient, uint256 amount) public payable {

        //console.log(balanceOf(recipient));
        
        require(msg.sender == owner, "Only owner can burn tokens");
        uint256 ethAmount = (amount * mtcToUsd) * (10**15)/ aaveToUsd;
        //console.log(ethAmount);
        console.log(balanceOf(recipient));
        console.log(ethAmount);
        console.log(aaveToUsd);
        require(balanceOf(recipient) >= ethAmount, "Insufficient balance");
        
        
        _burn(recipient, ethAmount);

        emit TokensBurned(recipient, amount, ethAmount);
    }

    function burnTokensWithUSD(address sender, uint256 usdAmount) external {
        require(msg.sender == owner, "Only owner can burn tokens");
        uint256 usdAmounttoburn = usdAmount * (10**15)/ aaveToUsd;
        console.log(balanceOf(sender));
        console.log(usdAmounttoburn);
        _burn(sender, usdAmounttoburn);
        emit TokensBurned(sender, usdAmount, usdAmounttoburn);
    }


    event TokensMinted(address indexed recipient, uint256 amount, uint256 aaveAmount);
    event TokensBurned(address indexed burner, uint256 amount, uint256 ethAmount);
    
}