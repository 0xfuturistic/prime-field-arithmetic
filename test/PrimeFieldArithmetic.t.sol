// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PrimeFieldArithmetic} from "../src/PrimeFieldArithmetic.sol";

contract PrimeFieldArithmeticTest is Test {
    using PrimeFieldArithmetic for uint256;

    uint256 PRIME = PrimeFieldArithmetic.PRIME;

    modifier assumeInField(uint256 value) {
        vm.assume(value < PRIME);
        _;
    }

    function testFuzz_Add(uint256 a, uint256 b) public assumeInField(a) assumeInField(b) {
        // we must avoid overflow when adding a and b
        vm.assume(type(uint256).max - a >= b);

        uint256 sum = a + b;
        while (sum >= PRIME) {
            sum -= PRIME;
        }
        assertEq(a.add(b), sum);
    }

    // Additional Tests for add
    function test_Add_Overflow() public {
        uint256 a = PRIME - 1;
        uint256 b = 1;
        assertEq(a.add(b), 0);
    }

    function test_Add_Commutativity(uint256 a, uint256 b) public assumeInField(a) assumeInField(b) {
        assertEq(a.add(b), b.add(a));
    }

    function test_Add_WithZero(uint256 a) public assumeInField(a) {
        assertEq(a.add(0), a);
    }

    function test_Add_EdgeCases() public {
        assertEq(uint256(0).add(PRIME - 1), PRIME - 1);
    }

    // Additional Tests for sub
    function test_Sub_Underflow() public {
        uint256 a = 0;
        uint256 b = 1;
        assertEq(a.sub(b), PRIME - 1);
    }

    function test_Sub_ZeroResult(uint256 a) public assumeInField(a) {
        assertEq(a.sub(a), 0);
    }

    function test_Sub_EdgeCases() public {
        assertEq((PRIME - 1).sub(0), PRIME - 1);
    }

    // Additional Tests for mul
    function test_Mul_Overflow(uint256 a, uint256 b) public assumeInField(a) assumeInField(b) {
        uint256 result = a.mul(b);
        // Specific checks based on known overflow scenarios or using modulo
    }

    function test_Mul_Commutativity(uint256 a, uint256 b) public assumeInField(a) assumeInField(b) {
        assertEq(a.mul(b), b.mul(a));
    }

    function test_Mul_MultiplicativeIdentity(uint256 a) public assumeInField(a) {
        assertEq(a.mul(1), a);
    }

    function test_Mul_ZeroCase(uint256 a) public assumeInField(a) {
        assertEq(a.mul(0), 0);
    }

    // Additional Tests for div
    function test_Div_ByNonZero(uint256 a, uint256 b) public assumeInField(a) assumeInField(b) {
        vm.assume(b != 0);
        assertEq(a.div(b), a.mul(b.inv()));
    }

    function test_Div_BySelf(uint256 a) public assumeInField(a) {
        vm.assume(a != 0);
        assertEq(a.div(a), 1);
    }

    function testFail_Div_ByZero(uint256 a) public assumeInField(a) {
        vm.expectRevert("division by zero");
        a.div(0);
    }

    // Additional Tests for exp
    function test_Exp_ZeroPower(uint256 a) public assumeInField(a) {
        assertEq(a.exp(0), 1);
    }

    function test_Exp_PowerOfOne(uint256 a) public assumeInField(a) {
        assertEq(a.exp(1), a % PRIME);
    }

    function test_Exp_WithPrime(uint256 a) public assumeInField(a) {
        // Test with specific values
    }

    function test_Exp_SpecificCases() public {
        // Test with known cases
    }

    // Additional Tests for inv
    function test_Inv_NonZero(uint256 a) public assumeInField(a) {
        vm.assume(a != 0);
        uint256 invA = a.inv();
        // Check the multiplication of a number and its inverse
    }

    function test_Inv_One() public {
        assertEq(uint256(1).inv(), 1);
    }

    function tesFail_Inv_ZeroInternal() public {
        vm.expectRevert();
        uint256(0).inv(); // Expected to revert
    }

    function test_Inv_WithPrime(uint256 a) public assumeInField(a) {
        // Test with specific values
    }
}
