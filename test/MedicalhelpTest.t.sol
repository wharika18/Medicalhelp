// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployMedicalhelp} from "../../script/DeployMedicalhelp.sol";
import {Medicalhelp} from "../../src/Medicalhelp.sol";

contract KickstarterTest is Test {
    DeployMedicalhelp public deployer;
    Medicalhelp public medicalhelp;

    address public constant USER1 = address(1);
    address public constant USER2 = address(1);
    address public constant USER3 = address(1);
    address public constant manager =
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address payable public Vendor = payable(address(1));
    uint256 counter = 0;

    function setUp() public {
        deployer = new DeployMedicalhelp();
        medicalhelp = deployer.run();
    }

    function testContractAcceptsValue() public {
        vm.prank(USER1);
        vm.deal(USER1, 10);

        medicalhelp.donate{value: 1}();
        assertEq(address(medicalhelp).balance, 1);
    }

    function testRequestRevertsIncaseOfBeyondLimit() public {
        vm.deal(address(medicalhelp), 1);
        vm.prank(manager);
        vm.expectRevert();

        medicalhelp.spendingRequest(10, Vendor);
    }

    function testRequestRevertsIfNotManager() public {
        vm.prank(USER1);
        vm.deal(USER1, 10);
        vm.expectRevert();
        medicalhelp.spendingRequest(1, Vendor);
    }
}
