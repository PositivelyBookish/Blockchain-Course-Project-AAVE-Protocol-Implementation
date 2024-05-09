# Aave Protocol Implementation on Blockchain

## Overview
This project aims to develop a lending and borrowing protocol on the blockchain inspired by Aave. The protocol allows users to lend cryptocurrency to earn interest and borrow against deposited collateral. It includes core features such as depositing, withdrawing, borrowing, and repaying, while managing collateralization and interest calculation.

## Objective
The primary objective is to create a decentralized lending and borrowing platform using Solidity smart contracts on the Polygon blockchain (formerly known as Matic). The project aims to replicate the functionalities of Aave's protocol, providing users with opportunities to lend their digital assets and borrow against deposited collateral.

## Key Features
- **Deposit/Lend:** Users can deposit their digital assets into the lending pool and earn interest on the amount they lend.
- **Withdraw:** Users can withdraw their deposited assets from the lending pool at any time.
- **Borrow:** Users can borrow digital assets from the lending pool by providing collateral as security.
- **Repay:** Borrowers can repay their loans along with accrued interest to reclaim their collateral.

## Stakeholders
- **Lenders:** Users who deposit digital assets into the lending pool to earn interest.
- **Borrowers:** Users who borrow digital assets from the lending pool by providing collateral.

## Smart Contracts
1. **ERC20.sol:** Manages AToken generation and burning based on user deposits and withdrawals from the lending pool.
2. **MyToken.sol:** Generates a custom currency (symbol: IBT) minted to users' accounts and used for transactions as a secondary cryptocurrency (for testing purposes).
3. **LendingPool.sol:** Provides core functionalities for the lending and borrowing protocol, including deposit, withdrawal, borrowing, and repayment, while managing collateralization, interest calculation, and interactions with ERC20.sol for AToken management.

## Technology Stack
- **Solidity:** Used to write the smart contracts defining the protocol's logic and functionalities.
- **Hardhat:** Utilized for project configuration, testing, and deployment of the smart contracts.
- **Polygon Amoy Testnet:** Chosen as the test network for deploying and testing the smart contracts, providing a scalable and low-cost environment for development and experimentation.

## Blockchain Structure
- **PoS Consensus:** Polygon utilizes a Proof of Stake (PoS) consensus mechanism where validators stake tokens to validate transactions and secure the network.
- **Validators and Staking:** Validators propose and validate blocks, while users can stake tokens as delegators to support validators and earn rewards.
- **Finality:** PoS provides faster and more predictable finality for transactions compared to Ethereum's PoW, enhancing transaction efficiency.
- **Scalability and Efficiency:** PoS contributes to Polygon's scalability and efficiency by reducing energy consumption and enabling faster block confirmation times.

## Programs/Code Deployment
- **Live Demo:**
    - MyToken.sol: [Link to deployed contract](https://amoy.polygonscan.com/address/0xB2def282Dd54101639D1e940eBd47D2F87dc8830)
    - LendingPool.sol: [Link to deployed contract](https://amoy.polygonscan.com/address/0xf2389E52327AdD85650C3A8DD1739822690BfC80)

## Results and Test Data
- [Link to test results]

## Conclusion
- The project has successfully developed a lending and borrowing protocol on the blockchain, inspired by Aave's functionalities.
- Utilizing Solidity and Hardhat, the team built a robust platform for financial activities deployed on the scalable and interoperable Polygon blockchain.
- Smart contracts ensure transparent and automated processes, including collateralization and interest rate management.
- Despite challenges such as interest rate management and currency creation, the project has effectively addressed them, offering a decentralized and efficient solution for users and fostering growth in the DeFi ecosystem.

## References
1. Aave Protocol Version 1.0 - Decentralized Lending Pools: [GitHub Repository](https://github.com/aave/aave-protocol)
2. Aave Protocol Whitepaper: [Link](https://github.com/aave/aave-protocol/blob/master/docs/Aave_Protocol_Whitepaper_v1_0.pdf)
3. Getting started with Hardhat: [Hardhat Documentation](https://hardhat.org/hardhat-runner/docs/getting-started#quick-start)
4. Introducing the Amoy Testnet for Polygon PoS: [Polygon Blog](https://polygon.technology/blog/introducing-the-amoy-testnet-for-polygon-pos)
5. Polygon Pos Chain Amoy Blockchain Explorer: [Amoy Testnet Explorer](https://amoy.polygonscan.com/)
6. AAVE tutorial (how to Lend & Borrow Crypto on AAVE): [YouTube](https://www.youtube.com/watch?v=2DfZXOijqcw)
