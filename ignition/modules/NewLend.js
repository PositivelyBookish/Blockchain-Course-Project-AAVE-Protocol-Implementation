const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("NewLend", (m) => {
  const newLend = m.contract("LendingPool", []);

  return { newLend };
});
