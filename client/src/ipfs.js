import { create } from 'ipfs-http-client'
import { contract, web3 } from '@/index.js'

async function ipfsClient () {
  return create(
    {
      host: 'localhost',
      port: '5002',
      protocol: 'http'
    }
  )
}

async function saveFile (file) {
  const ipfs = await ipfsClient()
  return await ipfs.add(file)
}

export const addNewCar = async (licensePlate, chassisNumber, brand, typeCar, colour, mileage, status, priceInETH, file, account) => {
  try {
    const price = web3.utils.toWei(priceInETH.toString(), 'ether')
    if (file != null) {
      await saveFile(file).then(response => {
        try {
          contract.methods.setCar(licensePlate, chassisNumber, brand, typeCar, colour, mileage,
            parseInt(status), price, response.path).send({ from: account }, function () {
            window.location.reload()
          })
        } catch (error) {
          console.log(error)
        }
      })
    } else {
      try {
        contract.methods.setCar(licensePlate, chassisNumber, brand, typeCar, colour, mileage,
          parseInt(status), price, '').send({ from: account }, function () {
          window.location.reload()
        })
      } catch (error) {
        console.log(error)
      }
    }
  } catch (error) {
    console.log(error)
  }
}
