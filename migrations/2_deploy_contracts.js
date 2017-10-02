var crowdfund = artifacts.require("./crowdfund.sol");

module.exports = function(deployer) {
  deployer.deploy(crowdfund);
};
