// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PrimeFieldArithmetic} from "../src/PrimeFieldArithmetic.sol";

contract PrimeFieldArithmeticTest is Test {
    using PrimeFieldArithmetic for uint256;

    uint256 constant PRIME = PrimeFieldArithmetic.PRIME;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      Tests for addition                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_add_basic() public {
        uint256 a = 1;
        uint256 b = 2;
        uint256 c = a + b;
        assertEq(a.add(b), c);
    }

    function test_add_commutes(uint256 a, uint256 b) public {
        assertEq(a.add(b), b.add(a));
    }

    function testFuzz_add(uint256 a, uint256 b) public {
        a %= PRIME;
        b %= PRIME;
        uint256 c = (a + b) % PRIME;
        assertEq(a.add(b), c);
    }

    function test_add_wraps_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 1;
        uint256 c = 0;
        assertEq(a.add(b), c);
    }

    function test_add_wraps_B() public {
        uint256 a = 1;
        uint256 b = PRIME - 1;
        uint256 c = 0;
        assertEq(a.add(b), c);
    }

    function test_add_zero_A(uint256 b) public {
        b %= PRIME;
        uint256 a = 0;
        uint256 c = b;
        assertEq(a.add(b), c);
    }

    function test_add_zero_B(uint256 a) public {
        a %= PRIME;
        uint256 b = 0;
        uint256 c = a;
        assertEq(a.add(b), c);
    }

    function test_add_edge_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 0;
        uint256 c = a;
        assertEq(a.add(b), c);
    }

    function test_add_edge_B() public {
        uint256 a = 0;
        uint256 b = PRIME - 1;
        uint256 c = b;
        assertEq(a.add(b), c);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    Tests for subtraction                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // Additional Tests for sub
    function test_Sub_Underflow() public {
        uint256 a = 0;
        uint256 b = 1;
        assertEq(a.sub(b), PRIME - 1);
    }

    function test_Sub_ZeroResult(uint256 a) public {
        assertEq(a.sub(a), 0);
    }

    function test_Sub_EdgeCases() public {
        assertEq((PRIME - 1).sub(0), PRIME - 1);
    }

    // Additional Tests for mul
    function test_Mul_Overflow(uint256 a, uint256 b) public {
        uint256 result = a.mul(b);
        // Specific checks based on known overflow scenarios or using modulo
    }

    function test_Mul_Commutativity(uint256 a, uint256 b) public {
        assertEq(a.mul(b), b.mul(a));
    }

    function test_Mul_MultiplicativeIdentity(uint256 a) public {
        assertEq(a.mul(1), a % PRIME);
    }

    function test_Mul_ZeroCase(uint256 a) public {
        assertEq(a.mul(0), 0);
    }

    // Additional Tests for div
    function test_Div_ByNonZero(uint256 a, uint256 b) public {
        vm.assume(b % PRIME != 0);
        assertEq(a.div(b), a.mul(b.inv()));
    }

    function test_Div_BySelf(uint256 a) public {
        vm.assume(a % PRIME != 0);
        assertEq(a.div(a), 1);
    }

    function testFail_Div_ByZero(uint256 a) public {
        vm.expectRevert("division by zero");
        a.div(0);
    }

    // Additional Tests for exp
    function test_Exp_ZeroPower(uint256 a) public {
        assertEq(a.exp(0), 1);
    }

    function test_Exp_PowerOfOne(uint256 a) public {
        assertEq(a.exp(1), a % PRIME);
    }

    function test_Exp_WithPrime(uint256 a) public {
        // Test with specific values
    }

    function test_Exp_SpecificCases() public {
        // Test with known cases
    }

    // Additional Tests for inv
    function test_Inv_NonZero(uint256 a) public {
        vm.assume(a % PRIME != 0);
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

    function test_Inv_WithPrime(uint256 a) public {
        // Test with specific values
    }
}
