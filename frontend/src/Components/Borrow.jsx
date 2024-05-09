import React from "react";
import { IoCheckmarkSharp } from "react-icons/io5";
import { IoMdClose } from "react-icons/io";
import { useNavigate } from "react-router-dom";

const Borrow = () => {
  const navigate = useNavigate(); // Initialize useNavigate

  const handleSupplyClick = () => {
    navigate("/borroweth"); // Navigate to the deposit page
  };

  const handleSupplyClickibt = () => {
    navigate("/borrowibt"); // Navigate to the deposit page
  };
  return (
    <div className="bg-slate-100 py-2 px-2 pl-7 border-[2px] border-slate-400 rounded-xl">
      <h1 className="font-medium text-lg ">Assets to Borrow</h1>
      <div className="grid grid-cols-4 gap-1 justify-between mt-5 border-b-2 py-1 border-slate-500">
        <div className="">Assets</div>
        <div>Available</div>
        <div>APY (%)</div>
        <div></div>
      </div>
      <div className="grid grid-cols-4 gap-1 justify-between mt-5 border-b-2 py-1 border-slate-400">
        <div className="font-semibold">ETH</div>
        <div>0</div>
        <div className="justify-center align-middle">0</div>
        <div className="ml-5">
          <button
            onClick={handleSupplyClick}
            className="bg-slate-300 px-4 py-1 mb-1 rounded-md hover:bg-slate-200 hover:text-slate-700"
          >
            Borrow
          </button>
        </div>
      </div>
      <div className="grid grid-cols-4 gap-1 justify-between mt-5 border-b-2 py-1 border-slate-400">
        <div className="font-semibold">IBT</div>
        <div>0</div>
        <div className="justify-center align-middle">0</div>
        <div className="ml-5">
          <button
            onClick={handleSupplyClickibt}
            className="bg-slate-300 px-4 py-1 mb-1 rounded-md hover:bg-slate-200 hover:text-slate-700"
          >
            Borrow
          </button>
        </div>
      </div>
    </div>
  );
};

export default Borrow;
