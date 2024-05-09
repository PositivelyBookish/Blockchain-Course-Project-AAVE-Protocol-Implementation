const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("FinalToken", (m) => {
  const finaltoken = m.contract("MyToken", []);

  return { finaltoken };
});
