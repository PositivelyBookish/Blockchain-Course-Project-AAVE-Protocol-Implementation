const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Lendnew", (m) => {
  const lendnew = m.contract("Lend", []);

  return { lendnew };
});
