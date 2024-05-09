const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("FinalLend", (m) => {
  const finallend = m.contract("LendingPool", []);

  return { finallend };
});
