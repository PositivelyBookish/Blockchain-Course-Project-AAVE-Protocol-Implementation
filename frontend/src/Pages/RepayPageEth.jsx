import React from "react";
import { IoMdClose } from "react-icons/io";
import { useNavigate } from "react-router-dom";

const RepayPageEth = () => {
  const navigate = useNavigate(); // Initialize useNavigate

  const handleCloseClick = () => {
    navigate("/"); // Navigate back to the root page
  };
  return (
    <div className="flex justify-center text-center items-center mx-auto my-auto h-[80vh]">
      <div className="w-[40%] bg-slate-100 rounded-lg border-[2px] border-slate-300">
        <div className="flex justify-between">
          <div className="flex pl-12 text-[20px] font-semibold my-3 text-left">
            Repay ETH
          </div>
          <div className="text-right my-3 pr-9">
            <button onClick={handleCloseClick}>
              <IoMdClose size={30} />
            </button>
          </div>
        </div>
        <div className="flex text-left pl-12">Amount</div>
        <div className="flex pl-12 my-2">
          <input
            type="text"
            className="border-2 flex justify-start border-gray-300 bg-white h-10 px-5 pr-16 rounded-lg text-sm focus:outline-none"
            placeholder="Enter amount of ETH"
          />
          <p className="justify-center flex mx-5 mt-2">ETH</p>
        </div>
        <div className="flex pl-12 my-2 border-b-2 border-slate-300">
          Transaction Overview
        </div>
        <div className="flex pl-12 my-2">
          <div className="grid grid-cols-2 gap-3">
            <div className="flex text-left">Remaining Debt</div>
            <div className="flex text-right ml-24">0.00000032 ETH</div>
          </div>
        </div>

        <div className="flex pl-12 pr-24 my-2 w-full">
          <button className="flex px-7 py-2 rounded-lg text-center items-center justify-center border-2 border-slate-400 my-2 bg-slate-300 w-full">
            Repay{" "}
          </button>
        </div>
      </div>
    </div>
  );
};

export default RepayPageEth;
