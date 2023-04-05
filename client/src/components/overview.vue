<template>
  <h1 class="h-10 flex justify-center items-center text-6xl text-white">Car overview</h1>
  <h2 class="h-10 mt-5 flex justify-center items-center text-white">Get the information of a specific car / edit car</h2>
  <h2 class="h-10 flex justify-center items-center text-white">Current account balance: <font-awesome-icon icon="fa-brands fa-ethereum" style="color: #ffffff;"/> {{balanceInEther}} ETH</h2>
  <div v-if="cars.length === 0" class="inline w-5 h-5 text-6xl text-white">
    There are no cars.
  </div>
  <div v-else>
    <div class="flex justify-center">
      <div v-for="(car, index) in cars" :key="index" class="rounded-md bg-white p-1 m-5">
        <button class="text-xl" @click="openModal(car); getMileageHistoryOfCar(car);
      getImageHashOfCar(car);">{{ car }}
        </button>
      </div>
    </div>
    <div v-if="this.open" class="flex justify-center">
      <informationModal
        :selected-car="selectedCar"
        :mileageHistory="mileageHistory"
        :currentAccount="account"
        :carImage="image"
        :index="index"
        :balance="balance"
        @setMileage="setNewMileage"
        @setNewPrice="setNewPrice"
        @setNewStatus="setNewStatus"
        @closeModal="this.open = false">
      </informationModal>
    </div>
  </div>
</template>

<script>
import { main, contract, web3 } from '@/index.js'
import modal from '@/components/modal.vue'

export default {
  mounted () {
    this.allCars()
    main().then(response => {
      this.account = response
      this.getBalanceUser()
    }).catch(e => {
      console.log(e)
    })
  },
  name: 'overviewPage',
  data () {
    return {
      index: null,
      open: false,
      selectedCar: '',
      cars: '',
      licensePlate: null,
      chassisNumber: null,
      brand: null,
      typeCar: null,
      colour: null,
      mileage: null,
      mileageHistory: null,
      status: null,
      price: null,
      image: null,
      account: null,
      balance: null,
      balanceInEther: null
    }
  },
  methods: {
    allCars () {
      contract.methods.getAllCars().call().then(response => {
        this.cars = response
      }).catch(e => {
        console.log(e)
      })
    },
    getBalanceUser () {
      try {
        contract.methods.getUserBalance(this.account).call().then(response => {
          this.balance = response
          this.balanceInEther = web3.utils.fromWei(response, 'ether')
        }).catch(e => {
          console.log(e)
        })
      } catch (error) {
        console.log(error)
      }
    },
    getMileageHistoryOfCar (licensePlate) {
      try {
        contract.methods.getMileageHistory(licensePlate).call().then(response => {
          this.mileageHistory = response
        }).catch(e => {
          console.log(e)
        })
      } catch (error) {
        console.log(error)
      }
    },
    getImageHashOfCar (licensePlate) {
      contract.methods.getImageHash(licensePlate).call().then(response => {
        this.image = 'http://127.0.0.1:9090/ipfs/' + response
      }).catch(e => {
        console.log(e)
      })
    },
    setNewMileage (licensePlate, newMileage) {
      if (newMileage > this.selectedCar.mileage) {
        if (confirm('Are you sure you want to change the mileage to: ' + newMileage + '?')) {
          try {
            contract.methods.setMileage(licensePlate, newMileage).send({ from: this.account }, function () {
              window.location.reload()
            })
          } catch (error) {
            console.log(error)
          }
        }
      } else {
        alert('The given mileage is the same or lower than the current mileage!')
      }
    },
    setNewPrice (licensePlate, newPrice) {
      const price = web3.utils.toWei(newPrice.toString(), 'ether')
      if (price !== this.selectedCar.price) {
        if (confirm('Are you sure you want to change the price to: ' + newPrice + ' ETH?')) {
          try {
            contract.methods.setPrice(licensePlate, price).send({ from: this.account }, function () {
              window.location.reload()
            })
          } catch (error) {
            console.log(error)
          }
        }
      } else {
        alert('The given price value is the same as the current one!')
      }
    },
    setNewStatus (licensePlate, newStatus) {
      if (newStatus !== this.selectedCar.status) {
        let text = 'Are you sure you want to change the status to: For sale?'

        if (newStatus === '0') {
          text = 'Are you sure you want to change the status to: Not for sale?'
        }

        if (confirm(text)) {
          try {
            contract.methods.setStatus(licensePlate, parseInt(newStatus)).send({ from: this.account }, function () {
              window.location.reload()
            })
          } catch (error) {
            console.log(error)
          }
        }
      } else {
        alert('The given status is the same as the current one!')
      }
    },
    openModal (car) {
      try {
        contract.methods.getCar(car).call().then(response => {
          this.selectedCar = response
        }).catch(e => {
          console.log(e)
        })
        this.open = true
      } catch (error) {
        console.log(error)
      }
    }
  },
  components: {
    informationModal: modal
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
