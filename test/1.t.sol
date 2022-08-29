// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1.sol";
import "../src/tokens/tokenInsecureum.sol";

contract InSecureumLenderPoolTest is Test {
    InSecureumLenderPool target;
    InSecureumToken token;
    address player;
    function setUp() public {

        token = new InSecureumToken(100);
        target = new InSecureumLenderPool(address(token));
        token.transfer(address(target) ,100);
        uint256 balance = token.balanceOf(address(target));
        emit log_named_uint("target balance", balance);
        player = vm.addr(1);
        vm.deal(player, 100 ether);
    }

    function testComplete() public {
        vm.startPrank(player);
        assertTrue(true);
    }
}
