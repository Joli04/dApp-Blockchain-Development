const carsSale = artifacts.require("carsSale");

module.exports = function (deployer) {
    deployer.deploy(carsSale);
}
