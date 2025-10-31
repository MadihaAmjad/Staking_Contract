// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;


import "forge-std/Test.sol";
import "src/Token/Staking.sol";
import "src/Token/Token.sol";



contract StakingTest is Test {
    Staking public staking;
    Token public token;

    address alice = address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    address bob = address(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);

    function setUp() public {
       token = new Token("ROI", "ROI", 18);
        token.mint(bob, 1000000 ether);
        staking = new Staking(address(token));

        // give Alice tokens
        token.mint(alice, 1000 ether);

       
        vm.startPrank(alice);
        token.approve(address(staking), 1000000 ether);
        vm.stopPrank();
    }

    function testDeposit() public {
        vm.startPrank(alice);

        staking.deposit(alice, 100 ether, bob);

        // check balances
        assertEq(token.balanceOf(address(staking)), 99.5 ether);
        vm.stopPrank();
    }

    function testClaimReward() public {
        vm.startPrank(alice);
        staking.deposit(alice, 100 ether, bob);

        // move forward in time
        vm.warp(block.timestamp + 1 days);

        staking.claimReward();

        // claim event test
        (, , , , uint256 staked,, ,) = staking.TokenHolderInfo(alice);
        console.log("Staked Amount:", staked);

        vm.stopPrank();
    }

    function testUnstake() public {
        vm.startPrank(alice);
        staking.deposit(alice, 100 ether, bob);

        // move 16 days forward
        vm.warp(block.timestamp + 16 days);

        staking.Unstake();

        // Check if unstake executed (balance reset)
        uint bal = token.balanceOf(alice);
        console.log("Balance after unstake:", bal);
        vm.stopPrank();
    }
}
