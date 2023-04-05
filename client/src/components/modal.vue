<template>
  <div class="container p-2 bg-white">
    <button @click="this.$emit('closeModal')">
      <font-awesome-icon icon="fa-solid fa-xmark" style="color: #ff0000;"/>
    </button>
    <h1><b>License Plate</b>: {{ selectedCar.licensePlate }}</h1>
    <h1><b>Chassis Number</b>: {{ selectedCar.chassisNumber }}</h1>
    <h1><b>Brand</b>: {{ selectedCar.brand }}</h1>
    <h1><b>Type Car</b>: {{ selectedCar.typeCar }}</h1>
    <h1><b>Colour</b>: {{ selectedCar.colour }}</h1>
    <div class="flex">
      <h1><b>Mileage</b>: {{ selectedCar.mileage }}</h1>
      <button class="ml-5" @click="this.editMileage = true;"
              v-if="selectedCar.owner === currentAccount && !editMileage">
        <font-awesome-icon icon="fa-solid fa-pen-to-square"/>
      </button>
      <input class="ml-5 border-solid border-2 rounded-md" v-model="newMileage" v-if="editMileage" type="number"
             placeholder="Enter new mileage">
      <button class="ml-5" @click="this.$emit('setMileage', selectedCar.licensePlate, newMileage);
        this.editMileage = false; this.$emit('closeModal');" v-if="selectedCar.owner === currentAccount && editMileage">
        <font-awesome-icon icon="fa-solid fa-check" style="color: #008000;"/>
      </button>
      <button class="ml-3" v-if="editMileage" @click="this.editMileage = false;">
        <font-awesome-icon icon="fa-solid fa-xmark" style="color: #ff0000;"/>
      </button>
    </div>
    <p v-if="selectedCar.owner === currentAccount && editMileage" class="text-red-600">
      The mileage will not change if you set a lower value than the current mileage
    </p>
    <div class="flex">
      <h1 class="mr-2"><b>Mileage History</b>: </h1>
      <div class="text-sm ml-2 mt-0.5" v-for="(mileage, index) in mileageHistory" :key="index">
         <b>APK inspection {{index+1}}:</b> {{mileage}}
      </div>
    </div>

    <div class="flex">
      <h1 v-if="parseInt(selectedCar.status) === 0"><b>Status</b>: Not for sale </h1>
      <h1 v-else><b>Status</b>: For sale</h1>
      <button class="ml-5" @click="this.editStatus = true;" v-if="selectedCar.owner === currentAccount && !editStatus">
        <font-awesome-icon icon="fa-solid fa-pen-to-square"/>
      </button>
      <div v-if="this.editStatus" class="ml-4">
        <input class="" type="radio" v-model="newStatus" value="1">
        <label class="m-2">For sale</label>
        <input type="radio" v-model="newStatus" value="0">
        <label class="m-1">Not for sale</label>
      </div>
      <button class="ml-5" @click="this.$emit('setNewStatus', selectedCar.licensePlate, newStatus);
        this.editStatus = false; this.$emit('closeModal');" v-if="selectedCar.owner === currentAccount && editStatus">
        <font-awesome-icon icon="fa-solid fa-check" style="color: #008000;"/>
      </button>
      <button class="ml-3" v-if="editStatus" @click="this.editStatus = false;">
        <font-awesome-icon icon="fa-solid fa-xmark" style="color: #ff0000;"/>
      </button>
    </div>

    <div class="flex">
      <h1><b>Price</b>:
        <font-awesome-icon icon="fa-brands fa-ethereum" style="color: #3c3c3d;"/>
        {{ selectedCar.price / 1e18 }} ETH
      </h1>
      <button class="ml-5" @click="this.editPrice = true;"
              v-if="selectedCar.owner === currentAccount && !editPrice">
        <font-awesome-icon icon="fa-solid fa-pen-to-square"/>
      </button>
      <input class="ml-5 border-solid border-2 rounded-md" v-model="newPrice" v-if="editPrice" type="number"
             placeholder="Enter new price">
      <button class="ml-5" @click="this.$emit('setNewPrice', selectedCar.licensePlate, newPrice);
        this.editPrice = false; this.$emit('closeModal');" v-if="selectedCar.owner === currentAccount && editPrice">
        <font-awesome-icon icon="fa-solid fa-check" style="color: #008000;"/>
      </button>
      <button class="ml-3" v-if="editPrice" @click="this.editPrice = false;">
        <font-awesome-icon icon="fa-solid fa-xmark" style="color: #ff0000;"/>
      </button>
    </div>
    <h1><b>Image of the Car:</b></h1>
    <img v-if="carImage != null" :src="carImage" alt="There is no picture of this car" class="h-52">
    <div class="flex">
      <button class="bg-blue-400 p-4 mt-2 rounded-md text-white" @click="buyTheCar(selectedCar.licensePlate)"
              v-if=" selectedCar.owner !== currentAccount && parseInt(selectedCar.status) === 1 ">Buy car
      </button>
      <button class="bg-green-400 p-4 mt-2 rounded-md text-white" @click="confirmCarPayment(selectedCar.licensePlate)"
              v-if="parseInt(selectedCar.status) === 0 && selectedCar.buyer === this.currentAccount">Confirm Payment
      </button>
      <button class="bg-red-700 p-4 ml-4 mt-2 rounded-md text-white" @click="cancelCarPayment(selectedCar.licensePlate)"
              v-if="parseInt(selectedCar.status) === 0 && selectedCar.buyer === this.currentAccount">Cancel Payment
      </button>
    </div>
  </div>
</template>

<script>
import { contract } from '@/index.js'

export default {
  name: 'modalPage',
  props: ['selectedCar', 'mileageHistory', 'carImage', 'currentAccount', 'index', 'balance'],
  data () {
    return {
      status: null,
      editMileage: false,
      editPrice: false,
      editStatus: false,
      newMileage: null,
      newPrice: null,
      newStatus: null,
      boughtCar: false
    }
  },
  methods: {
    buyTheCar (licensePlate) {
      if (this.balance >= this.selectedCar.price) {
        if (confirm('Are you sure you want to buy car: ' + licensePlate + '?')) {
          try {
            contract.methods.buyCar(licensePlate).send({ from: this.currentAccount }, function () {
              window.location.reload()
            })
          } catch (error) {
            console.log(error)
          }
        }
      } else {
        alert("You don't have enough money on your account!")
      }
    },
    confirmCarPayment (licensePlate) {
      if (confirm('Did you receive car: ' + licensePlate + '?')) {
        try {
          contract.methods.confirmPayment(licensePlate).send({ from: this.currentAccount }, function () {
            window.location.reload()
          })
        } catch (error) {
          console.log(error)
        }
      }
    },
    cancelCarPayment (licensePlate) {
      if (confirm('Do you want to cancel the order of car: ' + licensePlate + '?')) {
        try {
          contract.methods.cancelPayment(licensePlate).send({ from: this.currentAccount }, function () {
            window.location.reload()
          })
        } catch (error) {
          console.log(error)
        }
      }
    }
  }
}
</script>

<style scoped>

</style>
