import { useEffect, useState } from "react";
import { ethers } from "ethers";

function Wallet() {
  let signer;
  let provider;

  const [addr, setAddr] = useState(""); //destination addr
  const [amount, setAmount] = useState("");
  const [balance, setBalance] = useState(0);
  const [accountAddr, setAccountAddr] = useState("");
  const [connected, setConnected] = useState(false);
  const [signerAddr, setSignerAddr] = useState(null);
  const [txStatus, setTxStatus] = useState("not-initialized");

  const connect = async () => {
    try {
      provider = new ethers.providers.Web3Provider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      signer = provider.getSigner();
      setSignerAddr(signer);

      const accAddr = await signer.getAddress();
      setAccountAddr(accAddr);
      setConnected(true);
      await checkbalance(signer);
    } catch (error) {
      console.log(error);
    }
  };

  const checkbalance = async (signer) => {
    const balance = await signer.getBalance();
    setBalance(balance);
  };

  return (
    <div>
      <nav className="bg-gray-200 p-4 border-b-2 border-black">
        <div className="flex justify-between">
          <div>
            <h1 className="text-4xl font-bold">Aave</h1>
          </div>

          <div>
            <button className="bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded">
              Balance: {ethers.utils.formatUnits(balance, 18)} Eth
            </button>
          </div>
          <div>
            <p className="text-gray-800 font-bold py-2 px-1">{accountAddr}</p>
          </div>
          <div>
            <button
              className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              onClick={(e) => {
                connect(e);
              }}
            >
              {connected ? "Connected" : "Connect to Metamask"}
            </button>
          </div>
        </div>
      </nav>

      {/* <div className="flex h-[100vh] w-full">
        <div className="m-auto">
          <div className="text-center mb-4">
            <div className="mb-3">
              <label htmlFor="accountAddr" className="form-label">
                Connected Account
              </label>
              <input
                id="accountAddr"
                type="text"
                value={accountAddr}
                aria-label="Account address"
                disabled
                readOnly
                className="border border-gray-300 rounded p-2"
              />
            </div>
            <div>
              <button className="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded">
                Balance: {ethers.utils.formatUnits(balance, 18)}
              </button>
            </div>
          </div>
        </div>
      </div> */}
    </div>
  );
}

export default Wallet;
