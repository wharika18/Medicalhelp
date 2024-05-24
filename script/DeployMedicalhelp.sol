// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/Medicalhelp.sol";

contract DeployMedicalhelp is Script {
    function run() external returns (Medicalhelp) {
        address manager = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startBroadcast();

        // Deploy the Kickstarter contract
        Medicalhelp medicalhelp = new Medicalhelp(manager);

        vm.stopBroadcast();
        return medicalhelp;
    }
}
