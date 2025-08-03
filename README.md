# DApp Car sales

A car sales DApp, where you can buy and sell cars using cryptocurrency.

## Features

- Add and widthdraw crypto from your store credit
- Buy cars
- Add cars to the marketplace

## Prerequisites

Before running this project, ensure you have the following installed and configured:

**MetaMask**  
   - [Download and install MetaMask](https://metamask.io) in your browser.  

**Ganache**  
   - [Download and install Ganache](https://trufflesuite.com/ganache/).  
   - Run Ganache for local blockchain testing.  

**MetaMask & Ganache Connection**  
   - Configure MetaMask to connect to Ganache using Ganache's **RPC URL**.

**IPFS Daemon Node (Kubo)**  
   - Install [IPFS Kubo](https://docs.ipfs.tech/install/command-line/#install-official-binary-distributions).  
   - Start a daemon node.  
   - Add the path to `ipfs.exe` to your **system environment variables** for easier access.  
   - If your node is **not running on port 5001**, update the port in `ipfs.js`.  

### Preventing CORS Errors

To prevent CORS issues when using IPFS, run the following commands after installing Kubo:

```bash
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin "[\"http://localhost:8080\"]"
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods "[\"PUT\", \"POST\", \"GET\"]"
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials "[\"true\"]"
```

## Installation

Clone the repository:

```bash
git clone https://github.com/Joli04/dApp-Blockchain-Development.git
```
**Configure the project to work with Ganache by updating the Truffle configuration.**

Navigate to the project folder:
```bash
cd project-name
```
Navigate to the smart contracts folder:
```bash
cd smart_contracts
```
Migrate the contracts:
```bash
truffle migrate
```
Navigate to the client folder:
```bash
cd ../client
```
Install the dependencies:
```bash
npm install
```
Run the project:
```bash
npm run serve
```
## License

[MIT](https://choosealicense.com/licenses/mit/)
