const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Lend", (m) => {
  const lend = m.contract("LendingPool", []);

  return { lend };
});
