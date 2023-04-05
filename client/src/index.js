import Web3 from 'web3'
import configuration from './contracts/carsSale.json'

const CONTRACT_ADDRESS = configuration.networks['5777'].address
const CONTRACT_ABI = configuration.abi
export const web3 = new Web3(Web3.givenProvider || new Web3.providers.HttpProvider('HTTP://127.0.0.1:7545'))
export const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS)
let account
export const main = async () => {
  try {
    const accounts = await web3.eth.requestAccounts()
    account = accounts[0]
    return account
  } catch (error) {
    console.log(error)
  }
}
if (typeof window.ethereum !== 'undefined') {
  window.ethereum.on('accountsChanged', function (accounts) {
    // This code will be executed when the user switches accounts in Metamask
    console.log('User switched accounts: ', accounts[0])
    window.location.reload()
  })
}
