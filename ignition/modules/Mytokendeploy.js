const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Mytokendeploy", (m) => {
  const mytokendeploy = m.contract("MyToken", []);

  return { mytokendeploy };
});
