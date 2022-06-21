const MultySig = artifacts.require("MultySig");

module.exports = function (deployer) {
  deployer.deploy(MultySig);
};
