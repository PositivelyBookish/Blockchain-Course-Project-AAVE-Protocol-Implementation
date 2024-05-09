// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;


import "./Erc20.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Lend {
    using SafeERC20 for IERC20;

    // Mapping to keep track of user balances
    mapping(address => uint256) public matic_balances;
    mapping(address => uint256) public ibt_balances;
    mapping(address => uint256) public collateral;
    mapping(address => uint256) public borrowedAmounts;
    mapping(address => bool) public isBorrower;
    mapping(address => uint256) public timestamp_borrow;
    mapping(address => bool) public isFirstRepay;
    mapping(address => uint256) public repayable_interest;
    uint256 public MTC_price;
    uint256 public matic_totalDeposits;
    uint256 public ibt_totalDeposits;
    mapping(address => uint256) public matic_interest_balances;
    mapping(address => uint256) public matic_deposit_timestamp;
    mapping(address => uint256) public matic_accruedInterest;
    mapping(address => uint256) public ibt_interest_balances;
    mapping(address => uint256) public ibt_deposit_timestamp;
    mapping(address => uint256) public ibt_accruedInterest;
    bool public ibt_isFirstWithdraw;
    bool public matic_isFirstWithdraw;
    mapping(address => uint256) public ibt_withdrawInterest;
    mapping(address => uint256) public matic_withdrawInterest;
    mapping(address => uint256) public borrowable_amount;

    // IBT token contract address
    AToken public token;
    address public ibtTokenAddress;

    event Deposit(address indexed user, uint256 amount, uint256 tokensMinted);
    event Withdraw(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    constructor() {
        token = new AToken();
        ibtTokenAddress = 0x1C1F26815308e35034d044f0d21e0f0f6B714AD1;
    }

    event BalanceAfterDeposit(address account, uint256 balance);
    event BalanceAfterWithdrawal(address account, uint256 balance);

    // Deposit MATIC
    function depositMatic() public payable {
        uint256 _maticAmount = msg.value;
        MTC_price = 0.72 * (10 ** 18);
        require(_maticAmount > 0, "Amount must be greater than 0");

        token.mintTokenswithMTC(msg.sender, _maticAmount); // Mint tokens directly to the user
        matic_balances[msg.sender] += _maticAmount;

        borrowable_amount[msg.sender] =
            (matic_balances[msg.sender] * (7) * (MTC_price)) /
            10;
        matic_totalDeposits += _maticAmount;
        if (matic_balances[msg.sender] == _maticAmount) {
            matic_isFirstWithdraw = true;
            matic_deposit_timestamp[msg.sender] = block.timestamp;
            matic_accruedInterest[msg.sender] = 0;
            matic_interest_balances[msg.sender] = _maticAmount;
        } else {
            matic_accruedInterest[msg.sender] +=
                ((block.timestamp - matic_deposit_timestamp[msg.sender]) *
                    matic_balances[msg.sender]) /
                1000000;
            matic_deposit_timestamp[msg.sender] = block.timestamp;
            matic_interest_balances[msg.sender] += _maticAmount;
        }
        console.log(matic_balances[msg.sender]);
        console.log(matic_deposit_timestamp[msg.sender]);
        console.log(matic_accruedInterest[msg.sender]);

        emit Deposit(msg.sender, _maticAmount, _maticAmount);
        emit BalanceAfterDeposit(msg.sender, matic_balances[msg.sender]);
    }

    // Deposit IBT tokens
    function depositIbt(uint256 _ibtamount) public {
        require(_ibtamount > 0, "Amount must be greater than 0");
        IERC20(ibtTokenAddress).safeTransferFrom(msg.sender, address(this), _ibtamount);
        token.mintTokensWithUSD(msg.sender, _ibtamount); // Mint tokens directly to the user
        ibt_balances[msg.sender] += _ibtamount;
        ibt_totalDeposits += _ibtamount;
        if (ibt_balances[msg.sender] == _ibtamount) {
            ibt_isFirstWithdraw = true;
            ibt_deposit_timestamp[msg.sender] = block.timestamp;
            ibt_accruedInterest[msg.sender] = 0;
            ibt_interest_balances[msg.sender] = _ibtamount;
        } else {
            ibt_accruedInterest[msg.sender] +=
                ((block.timestamp - ibt_deposit_timestamp[msg.sender]) *
                    ibt_balances[msg.sender]) /
                1000000;
            ibt_deposit_timestamp[msg.sender] = block.timestamp;
            ibt_interest_balances[msg.sender] += _ibtamount;
        }
        console.log(ibt_balances[msg.sender]);
        console.log(ibt_deposit_timestamp[msg.sender]);
        console.log(ibt_accruedInterest[msg.sender]);

        emit Deposit(msg.sender, _ibtamount, _ibtamount);
        emit BalanceAfterDeposit(msg.sender, ibt_balances[msg.sender]);
    }

    // Withdraw MATIC
    function withdrawMatic(uint256 amount) public {
        require(matic_balances[msg.sender] >= amount, "Insufficient MATIC balance");
        matic_balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Withdraw IBT tokens
    function withdrawIbt(uint256 amount) public {
        require(ibt_balances[msg.sender] >= amount, "Insufficient IBT balance");
        ibt_balances[msg.sender] -= amount;
        IERC20(ibtTokenAddress).safeTransfer(msg.sender, amount);
    }
}
