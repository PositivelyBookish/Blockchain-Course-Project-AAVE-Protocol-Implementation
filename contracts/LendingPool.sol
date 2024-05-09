// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "./Erc20.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LendingPool {
    mapping(address => uint256) public matic_balances;
    mapping(address => uint256) public ibt_balances;
    mapping(address => uint256) public matic_borrowedAmounts;
    mapping(address => uint256) public ibt_borrowedAmounts;
    mapping(address => bool) public matic_isBorrower;
    mapping(address => bool) public ibt_isBorrower;
    mapping(address => uint256) public matic_timestamp_borrow;
    mapping(address => uint256) public ibt_timestamp_borrow;
    mapping(address => bool) public matic_isFirstRepay;
    mapping(address => bool) public ibt_isFirstRepay;
    mapping(address => uint256) public matic_repayable_interest;
    mapping(address => uint256) public ibt_repayable_interest;
    uint256 public MTC_price;
    uint256 public matic_totalDeposits;
    uint256 public ibt_totalDeposits;
    mapping(address => uint256) public matic_interest_balances;
    mapping(address => uint256) public matic_deposit_timestamp;
    mapping(address => uint256) public matic_accruedInterest;
    mapping(address => uint256) public ibt_interest_balances;
    mapping(address => uint256) public ibt_deposit_timestamp;
    mapping(address => uint256) public ibt_accruedInterest;
    mapping(address => uint256) public total_borrowed;
    bool public ibt_isFirstWithdraw;
    bool public matic_isFirstWithdraw;
    mapping(address => uint256) public ibt_withdrawInterest;
    mapping(address => uint256) public matic_withdrawInterest;
    mapping(address => uint256) public borrowable_amount;

    AToken public token; // Token contract address
    ERC20 public mytoken_address;

    event Deposit(address indexed user, uint256 amount, uint256 tokensMinted);
    event Withdraw(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);


    constructor() payable{
        token = new AToken();
        mytoken_address = ERC20(0xB2def282Dd54101639D1e940eBd47D2F87dc8830);
        ibt_totalDeposits = mytoken_address.balanceOf(address(this));

        //mytoken_address = ERC20(0xe992fa5B88881Fd8a1F9b3D093d3bc6F47abBB8F);
    }

    event BalanceAfterDeposit(address account, uint256 balance);
    event BalanceAfterWithdrawal(address account, uint256 balance);

    // Deposit funds into the lending pool and mint tokens
    function depositMATIC() external payable {
        uint256 _maticAmount = msg.value;
        MTC_price = 1.72 * (10 ** 18);
        require(_maticAmount > 0, "Amount must be greater than 0");

        token.mintTokenswithMTC(msg.sender, _maticAmount); // Mint tokens directly to the user
        matic_balances[msg.sender] += _maticAmount;

        
        matic_totalDeposits += _maticAmount;
        if (matic_balances[msg.sender] == _maticAmount) {
            matic_isFirstWithdraw = true;
            borrowable_amount[msg.sender] = 0;
            matic_deposit_timestamp[msg.sender] = block.timestamp;
            matic_accruedInterest[msg.sender] = 0;
            matic_interest_balances[msg.sender] = _maticAmount;
        } else {

            matic_accruedInterest[msg.sender] += ((block.timestamp - matic_deposit_timestamp[msg.sender]) * matic_balances[msg.sender]) / 1000000;
            matic_deposit_timestamp[msg.sender] = block.timestamp;
            matic_interest_balances[msg.sender] += _maticAmount;
        }
        borrowable_amount[msg.sender] += (_maticAmount * (7) * (MTC_price)) /10**19;
        console.log(matic_balances[msg.sender]);
        console.log(matic_deposit_timestamp[msg.sender]);
        console.log(matic_accruedInterest[msg.sender]);

        emit Deposit(msg.sender, _maticAmount, _maticAmount);
        emit BalanceAfterDeposit(msg.sender, matic_balances[msg.sender]);
    }

    function depositIBT(uint256 _tokenAmount) external {
        uint256 _ibtAmount = _tokenAmount;
        require(_ibtAmount > 0, "Amount must be greater than 0");
        require(
            mytoken_address.transferFrom(msg.sender, address(this), _ibtAmount),
            "Transfer failed"
        );

        token.mintTokensWithUSD(msg.sender, _ibtAmount); // Mint tokens directly to the user
        ibt_balances[msg.sender] += _ibtAmount;
        ibt_totalDeposits = mytoken_address.balanceOf(address(this));
        if (ibt_balances[msg.sender] == _ibtAmount) {
            ibt_isFirstWithdraw = true;
            ibt_deposit_timestamp[msg.sender] = block.timestamp;
            ibt_accruedInterest[msg.sender] = 0;
            ibt_interest_balances[msg.sender] = _ibtAmount;
        } else {
            ibt_accruedInterest[msg.sender] +=
                ((block.timestamp - ibt_deposit_timestamp[msg.sender]) *
                    ibt_balances[msg.sender]) /
                1000000;
            ibt_deposit_timestamp[msg.sender] = block.timestamp;
            ibt_interest_balances[msg.sender] += _ibtAmount;
        }
        console.log(ibt_balances[msg.sender]);
        console.log(ibt_deposit_timestamp[msg.sender]);
        console.log(ibt_accruedInterest[msg.sender]);

        emit Deposit(msg.sender, _ibtAmount, _ibtAmount);
        emit BalanceAfterDeposit(msg.sender, ibt_balances[msg.sender]);
    }

    function withdrawIBT(uint256 _amount) external payable{
        uint256 time_now;
        time_now = block.timestamp;
        console.log(ibt_balances[msg.sender]);
        require(ibt_balances[msg.sender] >= _amount, "Insufficient balance");

        //require(mytoken_address.transfer(msg.sender, _amount), "Transfer failed");
        if (ibt_isFirstWithdraw) {
            ibt_withdrawInterest[msg.sender] = ((
                ibt_accruedInterest[msg.sender]
            ) +
                ((time_now - ibt_deposit_timestamp[msg.sender]) *
                    ibt_balances[msg.sender]) /
                1000000);
            console.log(ibt_withdrawInterest[msg.sender]);
            mytoken_address.transfer(msg.sender,
                _amount + ibt_withdrawInterest[msg.sender]
            );
            ibt_withdrawInterest[msg.sender] = 0;

            ibt_interest_balances[msg.sender] -= _amount;
            ibt_isFirstWithdraw = false;
        } else if (!ibt_isFirstWithdraw) {
            ibt_withdrawInterest[msg.sender] = (((time_now -
                ibt_deposit_timestamp[msg.sender]) * ibt_balances[msg.sender]) /
                1000000);
            console.log(ibt_withdrawInterest[msg.sender]);
            mytoken_address.transfer(msg.sender,
                _amount + ibt_withdrawInterest[msg.sender]
            );
            ibt_interest_balances[msg.sender] -= _amount;
            ibt_withdrawInterest[msg.sender] = 0;
        }

        ibt_deposit_timestamp[msg.sender] = time_now;
        token.burnTokensWithUSD(msg.sender, _amount);
        ibt_balances[msg.sender] -= _amount;
        ibt_totalDeposits = mytoken_address.balanceOf(address(this));
        console.log("Balances Left :");
        console.log(ibt_balances[msg.sender]);

        emit Withdraw(msg.sender, _amount);
    }


    function withdrawMATIC(uint256 _amount) public {
        uint256 time_now;
        time_now = block.timestamp;
        console.log(matic_balances[msg.sender]);
        require(matic_balances[msg.sender] >= _amount, "Insufficient balance");
        require((matic_balances[msg.sender]-_amount)*(7)*(MTC_price)/10**19>= total_borrowed[msg.sender], "Sori! Collateral depreciated :( ");
        //require(total_borrowed[msg.sender] == 0, "Sorry can't withdraw until the debt is cleared.");
        if (matic_isFirstWithdraw) {
            matic_withdrawInterest[msg.sender] = ((
                matic_accruedInterest[msg.sender]
            ) +
                ((time_now - matic_deposit_timestamp[msg.sender]) *
                    matic_balances[msg.sender]) /
                1000000);
            console.log(matic_withdrawInterest[msg.sender]);
            payable(msg.sender).transfer(
                _amount + matic_withdrawInterest[msg.sender]
            );
            matic_withdrawInterest[msg.sender] = 0;

            matic_interest_balances[msg.sender] -= _amount;
            matic_isFirstWithdraw = false;

        } else if (!matic_isFirstWithdraw) {
            matic_withdrawInterest[msg.sender] = (((time_now -
                matic_deposit_timestamp[msg.sender]) *
                matic_balances[msg.sender]) / 1000000);
            console.log(matic_withdrawInterest[msg.sender]);
            payable(msg.sender).transfer(
                _amount + matic_withdrawInterest[msg.sender]
            );
            matic_interest_balances[msg.sender] -= _amount;
            
        }
        
        matic_deposit_timestamp[msg.sender] = time_now;
        token.burnTokenswithMTC(msg.sender, _amount);
        matic_balances[msg.sender] -= _amount;
        borrowable_amount[msg.sender] =
            (matic_balances[msg.sender] * (MTC_price) * 7) /
            10**19;
        matic_totalDeposits -= _amount+ matic_withdrawInterest[msg.sender];
        console.log("Balances Left :");
        console.log(matic_balances[msg.sender]);
        matic_withdrawInterest[msg.sender] = 0;
        emit Withdraw(msg.sender, _amount);
    }


    function borrow_matic(uint256 _amount) external payable {
        require(!matic_isBorrower[msg.sender], "You have already borrowed funds! Clear Debt To borrow again!");
        require(matic_totalDeposits>_amount,"Not Enough Funds!");
        require(msg.value>_amount || (borrowable_amount[msg.sender]*(10**18)/MTC_price) >_amount,"Provide Collateral To continue the transaction");
        
        
        matic_timestamp_borrow[msg.sender] = block.timestamp;

        // Additional checks and state update
        
        matic_borrowedAmounts[msg.sender] += _amount;
        total_borrowed[msg.sender] += _amount*(MTC_price)/10**18;
        borrowable_amount[msg.sender] -= _amount*(MTC_price)/10**18;
        matic_isBorrower[msg.sender] = true;
        matic_isFirstRepay[msg.sender] = true;
        matic_totalDeposits -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Borrow(msg.sender, _amount);
    }

    function borrow_ibt(uint256 _amount) external payable {
        ibt_totalDeposits = mytoken_address.balanceOf(address(this));
        require(!ibt_isBorrower[msg.sender], "You have already borrowed funds! Clear Debt To borrow again!");
        require(ibt_totalDeposits>_amount,"Not Enough Funds");
        require(msg.value>_amount || borrowable_amount[msg.sender]>_amount,"Provide Collateral To continue the transaction");
        
        
        ibt_timestamp_borrow[msg.sender] = block.timestamp;

        // Additional checks and state update
        
        ibt_borrowedAmounts[msg.sender] += _amount;
        total_borrowed[msg.sender] += _amount;
        borrowable_amount[msg.sender] -= _amount;
        ibt_isBorrower[msg.sender] = true;
        ibt_isFirstRepay[msg.sender] = true;
        
        mytoken_address.transfer(msg.sender,_amount);
        ibt_totalDeposits = mytoken_address.balanceOf(address(this));
        emit Borrow(msg.sender, _amount);

    }

    function matic_repay() external payable{
        require(matic_isBorrower[msg.sender],"You have not borrowed any funds!");
        uint256 time_now;
        time_now = block.timestamp;
        console.log("Borrowed at timestamp : ");
        console.log(matic_timestamp_borrow[msg.sender]);

        if(matic_isFirstRepay[msg.sender]){
            matic_repayable_interest[msg.sender] = 0;
            matic_isFirstRepay[msg.sender] = false;
        }

        matic_repayable_interest[msg.sender] +=(time_now - matic_timestamp_borrow[msg.sender])*matic_borrowedAmounts[msg.sender]/100000;
        console.log("Interest : ");
        console.log(matic_repayable_interest[msg.sender]);

        uint256 total_repayable;
        total_repayable = matic_repayable_interest[msg.sender] + matic_borrowedAmounts[msg.sender];
        
        matic_timestamp_borrow[msg.sender] = time_now;

        if (msg.value >= total_repayable) {
            

            matic_isBorrower[msg.sender] = false;
            if (msg.value > total_repayable) {
                
                // Return Extra funds and collateral
                payable(msg.sender).transfer(msg.value - total_repayable);
                
                

                console.log("Sent Back excess Funds and Collateral!");
                console.log(msg.value - total_repayable);
                
            }
            
            matic_totalDeposits += total_repayable;
            borrowable_amount[msg.sender] += matic_borrowedAmounts[msg.sender]*(MTC_price)/10**18;
            total_borrowed[msg.sender] -= matic_borrowedAmounts[msg.sender]*(MTC_price)/10**18;
            matic_borrowedAmounts[msg.sender] = 0;
            matic_repayable_interest[msg.sender] = 0;
            
        }
        else{
            matic_isBorrower[msg.sender] = true;

            if(matic_repayable_interest[msg.sender]<= msg.value){
                borrowable_amount[msg.sender] += (msg.value-matic_repayable_interest[msg.sender])*(MTC_price)/10**18;
                total_borrowed[msg.sender] -= (msg.value-matic_repayable_interest[msg.sender])*(MTC_price)/10**18;
                matic_borrowedAmounts[msg.sender] -= msg.value-matic_repayable_interest[msg.sender];
                matic_repayable_interest[msg.sender] = 0;

            }
            else{
                matic_repayable_interest[msg.sender] -= msg.value;
            }
            matic_totalDeposits += msg.value;         
            
            
        }
    

    emit Repay(msg.sender, msg.value);



    }

    function ibt_repay(uint256 _amount) external{
        uint256 repay_amnt = _amount;

        require(ibt_isBorrower[msg.sender],"You have not borrowed any funds!");
        require(mytoken_address.transferFrom(msg.sender, address(this), repay_amnt));
        uint256 time_now;
        time_now = block.timestamp;
        console.log("Borrowed at timestamp : ");
        console.log(ibt_timestamp_borrow[msg.sender]);

        if(ibt_isFirstRepay[msg.sender]){
            ibt_repayable_interest[msg.sender] = 0;
            ibt_isFirstRepay[msg.sender] = false;
        }

        ibt_repayable_interest[msg.sender] +=(time_now - ibt_timestamp_borrow[msg.sender])*ibt_borrowedAmounts[msg.sender]/100000;
        console.log("Interest : ");
        console.log(ibt_repayable_interest[msg.sender]);

        uint256 total_repayable;
        total_repayable = ibt_repayable_interest[msg.sender] + ibt_borrowedAmounts[msg.sender];
        
        ibt_timestamp_borrow[msg.sender] = time_now;

        if (repay_amnt >= total_repayable) {
            

            ibt_isBorrower[msg.sender] = false;
            if (repay_amnt > total_repayable) {
                
                // Return Extra funds and collateral
                mytoken_address.transfer(msg.sender, repay_amnt - total_repayable);
                

                console.log("Sent Back excess Funds and Collateral!");
                console.log(repay_amnt - total_repayable);
                
            }

            ibt_totalDeposits = mytoken_address.balanceOf(address(this));
            borrowable_amount[msg.sender] += ibt_borrowedAmounts[msg.sender];
            total_borrowed[msg.sender] -= ibt_borrowedAmounts[msg.sender];
            ibt_borrowedAmounts[msg.sender] = 0;
            ibt_repayable_interest[msg.sender] = 0;
            
        }
        else{
            ibt_isBorrower[msg.sender] = true;

            if(ibt_repayable_interest[msg.sender]<= repay_amnt){
                borrowable_amount[msg.sender] += repay_amnt-ibt_repayable_interest[msg.sender];
                total_borrowed[msg.sender] -= repay_amnt-ibt_repayable_interest[msg.sender];
                ibt_borrowedAmounts[msg.sender] -= repay_amnt-ibt_repayable_interest[msg.sender];
                ibt_repayable_interest[msg.sender] = 0;

            }
            else{
                ibt_repayable_interest[msg.sender] -= repay_amnt;
            }
            ibt_totalDeposits = mytoken_address.balanceOf(address(this));         
            
            
        }
    

    emit Repay(msg.sender, repay_amnt);



    }

}