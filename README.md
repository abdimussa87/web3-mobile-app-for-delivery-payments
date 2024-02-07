# web3-mobile-app-for-delivery-payments

## Overview

GeoLogix Solutions revolutionises the logistics and delivery industry with its state-of-the-art GPS and blockchain technology. This pioneering company ensures timely deliveries within designated zones through an Ethereum-based dApp, a
automatically rewarding drivers for geographical compliance. GeoLogix sets a new benchmark in efficiency, reliability, and transparency, leading the way in tech-driven logistics solutions.GeoLogix Solutions utilises a location-based smart contract to facilitate automatic payments for drivers who remain within specified geographic zones for set durations. This system involves drivers' smartphones transmitting GPS data to an Ethereum smart contract at predetermined intervals. When a driver meets the conditions outlined in the contract, a cryptocurrency transaction is processed as payment.

Should GPS tracking reveal a driver straying from the assigned area, the smart contract updates to reflect non-compliance, impacting the driver's internal rating. This rating system evaluates drivers, penalising deviations with lower scores, while rewarding adherence with higher ratings. An ERC20 token is integrated into the smart contract, serving as the basis for a rewards system. Drivers who consistently meet compliance criteria receive these tokens as additional incentives, enhancing their performance. These tokens can be utilised within GeoLogix's ecosystem or converted into other cryptocurrencies or goods.
The project's goal is to develop and deploy an Ethereum-based decentralised application (dApp) that includes a thoroughly tested smart contract on a testnet, accompanied by a user interface for real-time status monitoring and management by GeoLogix Solutions

## Expected outcome

- Setup tool chains to build and deploy Ethereum based smart contracts
- Program in Solidity using Brownie or Hardhat
- Test and debug smart contracts

## Tools used

- Ethereum blockchain technology
- Hardhat compiler
- Sepolia testnet
- Alchemy blockchain node provider

## Installation / Setup and running steps

Include a _.env_ file with the following format:

<pre>
ALCHEMY_TESTNET_RPC_URL = ""
PRIVATE_KEY = ""
</pre>

Deploy the contract by running the following commands on your terminal:

<pre>
> npm install
> npx hardhat compile
> npx hardhat run scripts/deploy.js --network sepolia </pre>

## References

1. Medium article, https://medium.com/ethereum-developers/the-ultimate-end-to-end-tutorial-to-create-and-deploy-a-fully-descentralized-dapp-in-ethereum-18f0cf6d7e0e
2. CryptoZombies tutorial, https://cryptozombies.io/
3. Etherum Stack Exchange, https://ethereum.stackexchange.com/
4. Hardhat docs, https://hardhat.org/
5. Ethers.js docs, https://docs.ethers.io/v5/
