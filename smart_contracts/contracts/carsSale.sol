//SPDX-License-Identifier: UNLICENSED
pragma solidity ^ 0.8.0;

contract carsSale{

    mapping(string => Car) cars;
    mapping(address => uint) balances;
    string[] allCars;
    uint[] mileageHistory;
    enum carStatus {
        NO_SALE,
        SALE
    }

    struct Car {
        string licensePlate;
        string chassisNumber;
        string brand;
        string typeCar;
        string colour;
        uint mileage;
        uint[] mileageHistory;
        carStatus status;
        uint256 price;
        string image;
        address payable owner;
        address payable buyer;
    }

    function addMoneyToAccount() external payable {
        require(msg.sender.balance > msg.value, "There is not enough ether on your wallet");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "There is not enough ether on your account");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
    function buyCar(string memory _licensePlate) public {
        require(balances[msg.sender] >= cars[_licensePlate].price, "There is not enough ether on your account");
        balances[msg.sender] -= cars[_licensePlate].price;
        cars[_licensePlate].status = carStatus(0);
        cars[_licensePlate].buyer = payable(msg.sender);
    }

    function confirmPayment(string memory _licensePlate) public {
        require(msg.sender == cars[_licensePlate].buyer, "Current user and buyer of the car are not the same");
        balances[cars[_licensePlate].owner] += cars[_licensePlate].price;
        cars[_licensePlate].owner = payable(msg.sender);
        cars[_licensePlate].buyer = payable(address(0));
    }

    function cancelPayment(string memory _licensePlate) public {
        require(msg.sender == cars[_licensePlate].buyer, "Current user and buyer of the car are not the same");
        balances[msg.sender] += cars[_licensePlate].price;
        cars[_licensePlate].status = carStatus(1);
        cars[_licensePlate].buyer = payable(address(0));
    }

    function getUserBalance(address payable user) public view returns(uint){
        return balances[user];
    }

    function getWalletBalance(address payable user) public view returns(uint){
        return user.balance;
    }

    function getAllCars() public view returns(string[] memory ) {
        return allCars;
    }

    function getImageHash(string memory _licensePlate) public view returns (string memory) {
        return cars[_licensePlate].image;
    }

    function getMileageHistory(string memory _licensePlate) public view returns (uint[] memory) {
        return cars[_licensePlate].mileageHistory;
    }

    function getCar(string memory _licensePlate) public view returns (Car memory) {
        return cars[_licensePlate];
    }

    function carExists(string memory _licensePlate) internal view returns(bool) {
        for (uint i = 0; i < allCars.length; i++) {
            if (keccak256(abi.encodePacked(allCars[i])) == keccak256(abi.encodePacked(_licensePlate))) {
                return true;
            }
        }
        return false;
    }

    function setCar(string memory _licensePlate, string memory _chassis_number, string memory _brand,
        string memory _type_car, string memory _colour, uint _mileage, carStatus _status, uint _price, string memory hash) public {
        require(!carExists(_licensePlate), "Car already exists");
        mileageHistory.push(_mileage);
        cars[_licensePlate] = Car(_licensePlate, _chassis_number, _brand, _type_car, _colour, _mileage, mileageHistory, _status, _price, hash, payable(msg.sender), payable(address(0)));
        allCars.push(_licensePlate);
    }

    function setStatus(string memory _licensePlate, carStatus _status) public {
        require(cars[_licensePlate].owner == msg.sender);
        cars[_licensePlate].status = _status;
    }

    function setPrice(string memory _licensePlate, uint _newPrice) public {
        require(cars[_licensePlate].owner == msg.sender);
        cars[_licensePlate].price = _newPrice;
    }

    function setMileage(string memory _licensePlate, uint _mileage) public {
        require(cars[_licensePlate].owner == msg.sender);
        require(_mileage > cars[_licensePlate].mileage);
        cars[_licensePlate].mileage = _mileage;
        cars[_licensePlate].mileageHistory.push(_mileage);
    }
}
