import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import App from "./App.jsx";
import "./index.css";
import DepositPageEth from "./Pages/DepositPageEth.jsx";
import DepositPageIBT from "./Pages/DepositPageIBT.jsx";
import BorrowPageEth from "./Pages/BorrowPageEth.jsx";
import BorrowPageIBT from "./Pages/BorrowPageIBT.jsx";
import WithdrawPageEth from "./Pages/WithdrawPageEth.jsx";
import WithdrawPageIBT from "./Pages/WithdrawPageIBT.jsx";
import RepayPageEth from "./Pages/RepayPageEth.jsx";
import RepayPageIBT from "./Pages/RepayPageIbt.jsx";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <Router>
      <Routes>
        <Route path="/" element={<App />} />
        {/* Add more routes as needed */}
        <Route path="/depositeth" element={<DepositPageEth />} />
        <Route path="/depositibt" element={<DepositPageIBT />} />
        <Route path="/borroweth" element={<BorrowPageEth />} />
        <Route path="/borrowibt" element={<BorrowPageIBT />} />
        <Route path="/withdraweth" element={<WithdrawPageEth />} />
        <Route path="/withdrawibt" element={<WithdrawPageIBT />} />
        <Route path="/repayeth" element={<RepayPageEth />} />
        <Route path="/repayibt" element={<RepayPageIBT />} />
      </Routes>
    </Router>
  </React.StrictMode>
);
