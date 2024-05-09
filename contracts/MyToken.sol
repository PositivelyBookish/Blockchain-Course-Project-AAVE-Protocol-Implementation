// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract MyToken is ERC20 {
    address public lendContractAddress;

    constructor() ERC20("MyToken", "IBT") {
        
    }
    function mintTokenswithMTC(address recipient) external {
        _mint(recipient, 100000000 * (10 ** 18));
    }
    function setLendContractAddress(address _lendContractAddress) external {
        lendContractAddress = _lendContractAddress;
    }

    function approveLendContract(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "Invalid spender address");
        require(amount <= balanceOf(msg.sender), "Insufficient balance");
        require(amount <= allowance(msg.sender, spender), "Amount exceeds allowance");

        _approve(msg.sender, spender, amount);
        return true;
    }
}