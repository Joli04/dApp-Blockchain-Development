<template>
  <h1 class="h-10 flex justify-center items-center text-6xl text-white">Car Sales</h1>
  <h2 class="h-10 mt-5 flex justify-center items-center text-white">Create a new Car</h2>
  <div class="flex justify-center">
    <div class="rounded-md bg-stone-50 pr-4">
      <form class="ml-36">
        <p class="mt-2">License Plate</p>
        <p>
          <input class="border-2 rounded-md"
                 type="text" v-model="licensePlate" placeholder="Enter the license plate" required>
        </p>

        <p class="mt-2">Chassis Number</p>
        <p>
          <input class="border-2 rounded-md"
                 type="text" v-model="chassisNumber" placeholder="Enter the Chassis Number" required>
        </p>

        <p class="mt-2">Brand</p>
        <p>
          <input class="border-2 rounded-md"
                 type="text" v-model="brand" placeholder="Enter the brand" required>
        </p>

        <p class="mt-2">Type car</p>
        <p>
          <input class="border-2 rounded-md"
                 type="text" v-model="typeCar" placeholder="Enter the type of car" required>
        </p>

        <p class="mt-2">Colour</p>
        <p>
          <input class="border-2 rounded-md"
                 type="text" v-model="colour" placeholder="Enter the colour" required>
        </p>

        <p class="mt-2">Mileage</p>
        <p>
          <input class="border-2 rounded-md"
                 type="number" v-model="mileage" placeholder="Enter the mileage of the car" required>
        </p>

        <p class="mt-2">Status</p>
        <input class="" type="radio" v-model="status" value="1">
        <label class="m-2">For sale</label>
        <input type="radio" v-model="status" value="0">
        <label class="m-1">Not for sale</label>

        <p class="mt-2">Price (in <b>ETH</b>)</p>
        <p>
          <input class="border-2 rounded-md"
                 type="number" v-model="price" placeholder="Enter the price of the car" required>
        </p>

        <p class="mt-2">Upload a picture of the car</p>
        <p>
          <input class="border-2 rounded-md"
                 type="file" @change="onFileSelected">
        </p>
        <button class=" bg-blue-400 m-5 p-5 text-white rounded-md" type="submit" @click='
    setupCar(licensePlate.toUpperCase(), chassisNumber, brand, typeCar, colour, mileage, status, price)'>Create Car
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import { contract, main } from '@/index.js'
import { addNewCar } from '@/ipfs'

export default {
  mounted () {
    this.allCars()
    main().then(response => {
      this.account = response
    }).catch(e => {
      console.log(e)
    })
  },
  name: 'homePage',
  data () {
    return {
      cars: '',
      selectedFile: null,
      account: null,
      licensePlate: '',
      chassisNumber: null,
      brand: null,
      typeCar: null,
      colour: null,
      mileage: 0,
      status: 0,
      price: 0
    }
  },
  methods: {
    allCars () {
      contract.methods.getAllCars().call().then(response => {
        this.cars = response
        console.log(this.cars)
      }).catch(e => {
        console.log(e)
      })
    },
    setupCar (licensePlate, chassisNumber, brand, typeCar, colour, mileage, status, price) {
      if (/[a-zA-Z]/.test(licensePlate) && /[a-zA-Z]/.test(chassisNumber) && /[a-zA-Z]/.test(brand) &&
        /[a-zA-Z]/.test(typeCar) && /[a-zA-Z]/.test(colour)) {
        if (!this.cars.includes(licensePlate)) {
          if (confirm('Are you sure you want to add this car?')) {
            try {
              addNewCar(licensePlate, chassisNumber, brand, typeCar, colour, mileage, status, price, this.selectedFile, this.account)
            } catch (error) {
              console.log(error)
            }
          }
        } else {
          alert('Car already exists')
        }
      } else {
        alert('One or more inputfield(s) do not have a letter.')
      }
    },
    onFileSelected (event) {
      this.selectedFile = event.target.files[0]
    }
  }
}
</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
