// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test, console} from "forge-std/Test.sol";
import {PrimeFieldArithmetic} from "../src/PrimeFieldArithmetic.sol";

contract PrimeFieldArithmeticTest is Test {
    using PrimeFieldArithmetic for uint256;

    uint256 PRIME = PrimeFieldArithmetic.PRIME;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      Tests for addition                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_add_basic() public {
        uint256 a = 1;
        uint256 b = 2;
        uint256 c = (a + b) % PRIME; // for consistency we use mod PRIME
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

    function test_add_zero() public {
        uint256 a = 0;
        uint256 b = 0;
        uint256 c = 0;
        assertEq(a.add(b), c);
    }

    function test_add_zero_A(uint256 b) public {
        uint256 a = 0;
        b %= PRIME;
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
    function test_sub_basic() public {
        uint256 a = 3;
        uint256 b = 2;
        uint256 c = (a - b) % PRIME; // for consistency we use mod PRIME
        assertEq(a.sub(b), c);
    }

    function testFuzz_sub(uint256 a, uint256 b) public {
        a %= PRIME;
        b %= PRIME;
        uint256 c;
        if (a >= b) {
            c = (a - b) % PRIME;
        } else {
            c = PRIME - (b - a);
        }
        assertEq(a.sub(b), c);
    }

    function test_sub_wraps() public {
        uint256 a = 0;
        uint256 b = 1;
        uint256 c = PRIME - 1;
        assertEq(a.sub(b), c);
    }

    function test_sub_zero() public {
        uint256 a = 0;
        uint256 b = 0;
        uint256 c = 0;
        assertEq(a.sub(b), c);
    }

    function test_sub_zero_A(uint256 b) public {
        uint256 a = 0;
        b %= PRIME;
        uint256 c = (PRIME - b) % PRIME;
        assertEq(a.sub(b), c);
    }

    function test_sub_zero_B(uint256 a) public {
        a %= PRIME;
        uint256 b = 0;
        uint256 c = a;
        assertEq(a.sub(b), c);
    }

    function test_sub_edge_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 0;
        uint256 c = a;
        assertEq(a.sub(b), c);
    }

    function test_sub_edge_B() public {
        uint256 a = 0;
        uint256 b = PRIME - 1;
        uint256 c = PRIME - b;
        assertEq(a.sub(b), c);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    Tests for multiplication                */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_mul_basic() public {
        uint256 a = 3;
        uint256 b = 2;
        uint256 c = (3 * 2) % PRIME; // for consistency we use mod PRIME
        assertEq(a.mul(b), c);
    }

    function test_mul_commutes(uint256 a, uint256 b) public {
        assertEq(a.mul(b), b.mul(a));
    }

    function test_mul_identity() public {
        uint256 a = 1;
        uint256 b = 1;
        uint256 c = 1;
        assertEq(a.mul(b), c);
    }

    function testFuzz_mul(uint256 a, uint256 b) public {
        a %= PRIME;
        b %= PRIME;
        uint256 c;
        unchecked {
            c = (a * b) % PRIME;
        }
        assertEq(a.mul(b), c);
    }

    function test_mul_wraps_A() public {
        uint256 a = PRIME;
        uint256 b = 1;
        uint256 c = 0;
        assertEq(a.mul(b), c);
    }

    function test_mul_wraps_B() public {
        uint256 a = 1;
        uint256 b = PRIME;
        uint256 c = 0;
        assertEq(a.mul(b), c);
    }

    function test_mul_zero() public {
        uint256 a = 0;
        uint256 b = 0;
        uint256 c = 0;
        assertEq(a.mul(b), c);
    }

    function test_mul_zero_A(uint256 b) public {
        uint256 a = 0;
        b %= PRIME;
        uint256 c = 0;
        assertEq(a.mul(b), c);
    }

    function test_mul_zero_B(uint256 a) public {
        a %= PRIME;
        uint256 b = 0;
        uint256 c = 0;
        assertEq(a.mul(b), c);
    }

    function test_mul_edge_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 1;
        uint256 c = a;
        assertEq(a.mul(b), c);
    }

    function test_mul_edge_B() public {
        uint256 a = 1;
        uint256 b = PRIME - 1;
        uint256 c = b;
        assertEq(a.mul(b), c);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   Tests for exponentiation                 */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_exp_basic() public {
        uint256 a = 1;
        uint256 b = 1;
        uint256 c = 1;
        assertEq(a.exp(b), c);
    }

    function test_exp_power_zero(uint256 base) public {
        base %= PRIME;
        uint256 exponent = 0;
        uint256 result = 1;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_power_one(uint256 base) public {
        base %= PRIME;
        uint256 exponent = 1;
        uint256 result = base;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_base_zero(uint256 exponent) public {
        uint256 base = 0;
        exponent %= PRIME;
        uint256 result = exponent == 0 ? 1 : 0;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_base_one(uint256 exponent) public {
        uint256 base = 1;
        exponent %= PRIME;
        uint256 result = 1;
        assertEq(base.exp(exponent), result);
    }

    function testFuzz_exp(uint256 base, uint256 exponent) public {
        base %= PRIME;
        exponent %= PRIME;
        uint256 result = base ** exponent;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_wrap() public {
        // TODO
    }

    function test_exp_edge() public {
        // TODO
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      Tests for inverse                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_inv_basic() public {
        uint256 a = 1;
        uint256 result = 1;
        assertEq(a.inv(), result);
    }

    function testFuzz_inv(uint256 a) public {
        a %= PRIME;
        vm.assume(a != 0);
        assertEq(mulmod(a.inv(), a, PRIME), 1);
    }

    function tesFail_inv_zero() public {
        uint256 a = 0;
        vm.expectRevert();
        a.inv();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      Tests for division                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_div_basic() public {
        uint256 a = 1;
        uint256 b = 1;
        uint256 result = 1;
        assertEq(a.div(b), result);
    }

    function test_div_zero_numerator(uint256 denominator) public {
        uint256 a = 0;
        denominator %= PRIME;
        vm.assume(denominator != 0);
        uint256 result = 0;
        assertEq(a.div(denominator), result);
    }

    function testFail_div_zero_denominator(uint256 a) public {
        vm.expectRevert("division by zero");
        a.div(0);
    }

    function test_div_self(uint256 a) public {
        a %= PRIME;
        vm.assume(a != 0);
        assertEq(a.div(a), 1);
    }

    function testFuzz_div(uint256 a, uint256 b) public {
        a %= PRIME;
        b %= PRIME;
        vm.assume(b != 0);
        uint256 result = mulmod(a, b.inv(), PRIME);
        assertEq(a.div(b), result);
    }
}
