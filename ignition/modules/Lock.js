const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Lock", (m) => {
  const lock = m.contract("LendingPool", []);

  return { lock };
});
