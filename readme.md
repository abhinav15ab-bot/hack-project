# 🛡️ ChainShield Smart Contracts

This repository contains the Solidity smart contracts for **Chain-Shield**, a cross-chain liquidation prevention protocol that uses social sentiment to predict and automatically protect user positions from market crashes.

## 📦 Deployments

Our core `ChainShield.sol` contract is live and verified on the following testnets:

| Network | Chain ID | Contract Address | Explorer |
| :------ | :------- | :--------------- | :------- |
| **Ethereum Sepolia** | `11155111` | `0xF34C09A1941410e87a778518A817BfA62FaEf6bA` | [View on Etherscan](https://sepolia.etherscan.io/address/0xF34C09A1941410e87a778518A817BfA62FaEf6bA) |
| **Polygon Amoy** | `80002` | `0x6787B450bFa80786f377B061C638232373DC0DA8` | [View on Polygonscan](https://amoy.polygonscan.com/address/0x6787B450bFa80786f377B061C638232373DC0DA8) |

## 📄 Contract ABI

The Application Binary Interface (ABI) required for frontend interaction can be found here: [`/abis/ChainShield.json`](./abis/ChainShield.json)

*(**Action:** You will need to create the `abis` folder and the `ChainShield.json` file next.)*

## 🛠️ Technology Stack

- **Language:** Solidity `^0.8.19`
- **Development Environment:** Remix IDE
- **Networks:** Ethereum Sepolia, Polygon Amoy

## ✨ Key Features

- **On-Chain Protection Records:** Every "Golden Apple" activation is stored immutably.
- **Cross-Chain Ready:** Architecture supports monitoring and recording on multiple EVM chains.
- **Verifiable:** All events are public and can be verified independently on block explorers.

## 🤝 How to Integrate (for Frontend Team)

1.  Use the contract ABI from the link above.
2.  Instantiate the contract in your web app using `ethers.js` or `web3.js` with one of the addresses from the deployments table.
3.  Call the `recordProtection()` function to log events.
4.  Listen for `GoldenAppleActivated` events to update the UI in real-time.
