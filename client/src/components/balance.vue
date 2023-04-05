<template>
  <h1 class="h-10 flex justify-center items-center text-6xl text-white">Balance</h1>
  <h2 class="h-10 mt-5 flex justify-center items-center text-white">Add/Remove money to/from your balance</h2>
    <div class="flex justify-center">
      <div class="flex justify-center">
        <div class="rounded-md bg-stone-50 pr-4">
          <form class="m-5 pl-2">
            <h1 class="text-2xl">Your current account balance: {{balance}} ETH</h1>
            <h1 class="text-2xl">Your current wallet balance: {{walletBalance}} ETH</h1>
            <p><b>Add / Withdraw</b> an amount to your <b>account / wallet</b> balance in <b>ETHER</b></p>
            <p>
              <input class="border-2 rounded-md"
                     type="number" v-model="amount" placeholder="Enter the amount." required>
            </p>
            <button class=" bg-blue-400 mt-3 mr-3 p-5 text-white rounded-md" type="submit" @click='addAmountToAccount()'>Add amount
            </button>
            <button class=" bg-red-400 mt-3 p-5 text-white rounded-md" type="submit" @click='withdrawMoney()'>Withdraw amount
            </button>
          </form>
        </div>
    </div>
  </div>
</template>

<script>
import { main, contract, web3 } from '@/index.js'
export default {
  mounted () {
    main().then(response => {
      this.account = response
      this.getBalanceUser()
    }).catch(e => {
      console.log(e)
    })
  },
  name: 'addToBalancePage',
  data () {
    return {
      amount: null,
      account: null,
      balance: null,
      walletBalance: null
    }
  },
  methods: {
    getBalanceUser () {
      try {
        contract.methods.getUserBalance(this.account).call().then(response => {
          this.balance = web3.utils.fromWei(response, 'ether')
          console.log('Current account balance: ' + this.balance)
        }).catch(e => {
          console.log(e)
        })
        contract.methods.getWalletBalance(this.account).call().then(response => {
          this.walletBalance = web3.utils.fromWei(response, 'ether')
          console.log('Current wallet balance: ' + this.walletBalance)
        }).catch(e => {
          console.log(e)
        })
      } catch (error) {
        console.log(error)
      }
    },
    addAmountToAccount () {
      if (this.amount <= this.walletBalance && this.amount !== 0) {
        if (confirm('Are you sure you want to add ' + this.amount + ' ETH on your account?')) {
          try {
            const amount = web3.utils.toWei(this.amount.toString(), 'ether')
            contract.methods.addMoneyToAccount().send({ value: amount, from: this.account }, function () {
              window.location.reload()
            })
          } catch (error) {
            console.log(error)
          }
        }
      } else {
        alert('You do not have enough ether on your wallet or the given value is 0!')
      }
    },
    withdrawMoney () {
      if (this.amount <= this.balance && this.amount !== 0) {
        if (confirm('Are you sure you want to withdraw ' + this.amount + ' ETH?')) {
          try {
            const amount = web3.utils.toWei(this.amount.toString(), 'ether')
            contract.methods.withdraw(amount).send({ from: this.account }, function () {
              window.location.reload()
            })
          } catch (error) {
            console.log(error)
          }
        }
      } else {
        alert('You do not have enough ether on your account or the given value is 0!')
      }
    }
  }
}
</script>

<style scoped>

</style>
