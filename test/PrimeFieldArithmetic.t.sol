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
        uint256 result = (a + b) % PRIME; // for consistency we use mod PRIME
        assertEq(a.add(b), result);
    }

    function test_add_commutes(uint256 a, uint256 b) public {
        assertEq(a.add(b), b.add(a));
    }

    function testFuzz_add(uint256 a, uint256 b) public {
        uint256 result = addmod(a, b, PRIME);
        assertEq(a.add(b), result);
    }

    function test_add_wraps_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 1;
        uint256 result = 0;
        assertEq(a.add(b), result);
    }

    function test_add_wraps_B() public {
        uint256 a = 1;
        uint256 b = PRIME - 1;
        uint256 result = 0;
        assertEq(a.add(b), result);
    }

    function test_add_zero() public {
        uint256 a = 0;
        uint256 b = 0;
        uint256 result = 0;
        assertEq(a.add(b), result);
    }

    function test_add_zero_A(uint256 b) public {
        uint256 a = 0;
        uint256 result = b % PRIME;
        assertEq(a.add(b), result);
    }

    function test_add_zero_B(uint256 a) public {
        uint256 b = 0;
        uint256 result = a % PRIME;
        assertEq(a.add(b), result);
    }

    function test_add_edge_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 0;
        uint256 result = a;
        assertEq(a.add(b), result);
    }

    function test_add_edge_B() public {
        uint256 a = 0;
        uint256 b = PRIME - 1;
        uint256 result = b;
        assertEq(a.add(b), result);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    Tests for subtraction                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_sub_basic() public {
        uint256 a = 3;
        uint256 b = 2;
        uint256 result = (a - b) % PRIME; // for consistency we use mod PRIME
        assertEq(a.sub(b), result);
    }

    function testFuzz_sub(uint256 a, uint256 b) public {
        a %= PRIME;
        b %= PRIME;
        uint256 result;
        if (a >= b) {
            result = (a - b) % PRIME;
        } else {
            result = PRIME - (b - a);
        }
        assertEq(a.sub(b), result);
    }

    function test_sub_wraps() public {
        uint256 a = 0;
        uint256 b = 1;
        uint256 result = PRIME - 1;
        assertEq(a.sub(b), result);
    }

    function test_sub_zero() public {
        uint256 a = 0;
        uint256 b = 0;
        uint256 result = 0;
        assertEq(a.sub(b), result);
    }

    function test_sub_zero_A(uint256 b) public {
        uint256 a = 0;
        uint256 result = (PRIME - b % PRIME) % PRIME;
        assertEq(a.sub(b), result);
    }

    function test_sub_zero_B(uint256 a) public {
        uint256 b = 0;
        uint256 result = a % PRIME;
        assertEq(a.sub(b), result);
    }

    function test_sub_edge_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 0;
        uint256 result = a;
        assertEq(a.sub(b), result);
    }

    function test_sub_edge_B() public {
        uint256 a = 0;
        uint256 b = PRIME - 1;
        uint256 result = PRIME - b;
        assertEq(a.sub(b), result);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    Tests for multiplication                */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_mul_basic() public {
        uint256 a = 3;
        uint256 b = 2;
        uint256 result = (a * b) % PRIME; // for consistency we use mod PRIME
        assertEq(a.mul(b), result);
    }

    function test_mul_commutes(uint256 a, uint256 b) public {
        assertEq(a.mul(b), b.mul(a));
    }

    function test_mul_identity() public {
        uint256 a = 1;
        uint256 b = 1;
        uint256 result = 1;
        assertEq(a.mul(b), result);
    }

    function testFuzz_mul(uint256 a, uint256 b) public {
        uint256 result = mulmod(a, b, PRIME);
        assertEq(a.mul(b), result);
    }

    function test_mul_wraps_A() public {
        uint256 a = PRIME;
        uint256 b = 1;
        uint256 result = 0;
        assertEq(a.mul(b), result);
    }

    function test_mul_wraps_B() public {
        uint256 a = 1;
        uint256 b = PRIME;
        uint256 result = 0;
        assertEq(a.mul(b), result);
    }

    function test_mul_zero() public {
        uint256 a = 0;
        uint256 b = 0;
        uint256 result = 0;
        assertEq(a.mul(b), result);
    }

    function test_mul_zero_A(uint256 b) public {
        uint256 a = 0;
        uint256 result = 0;
        assertEq(a.mul(b), result);
    }

    function test_mul_zero_B(uint256 a) public {
        uint256 b = 0;
        uint256 result = 0;
        assertEq(a.mul(b), result);
    }

    function test_mul_edge_A() public {
        uint256 a = PRIME - 1;
        uint256 b = 1;
        uint256 result = a;
        assertEq(a.mul(b), result);
    }

    function test_mul_edge_B() public {
        uint256 a = 1;
        uint256 b = PRIME - 1;
        uint256 result = b;
        assertEq(a.mul(b), result);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   Tests for exponentiation                 */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function test_exp_basic() public {
        uint256 a = 1;
        uint256 b = 1;
        uint256 result = 1;
        assertEq(a.exp(b), result);
    }

    function test_exp_power_zero(uint256 base) public {
        uint256 exponent = 0;
        uint256 result = 1;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_power_one(uint256 base) public {
        uint256 exponent = 1;
        uint256 result = base % PRIME;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_base_zero(uint256 exponent) public {
        uint256 base = 0;
        uint256 result = exponent % PRIME == 0 ? 1 : 0;
        assertEq(base.exp(exponent), result);
    }

    function test_exp_base_one(uint256 exponent) public {
        uint256 base = 1;
        uint256 result = 1;
        assertEq(base.exp(exponent), result);
    }

    function testFuzz_exp(uint256 base, uint256 exponent) public {
        // TODO
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
        vm.assume(a % PRIME != 0);
        assertEq(mulmod(a.inv(), a, PRIME), 1);
    }

    function tesFail_inv_zero() public {
        uint256 a = 0;
        vm.expectRevert("cannot divide by zero");
        a.inv();
    }

    function tesFail_inv_prime() public {
        vm.expectRevert("cannot divide by zero");
        PRIME.inv();
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
        vm.assume(denominator % PRIME != 0);
        uint256 result = 0;
        assertEq(a.div(denominator), result);
    }

    function testFail_div_zero_denominator(uint256 a) public {
        vm.expectRevert("division by zero");
        a.div(0);
    }

    function test_div_self(uint256 a) public {
        vm.assume(a % PRIME != 0);
        assertEq(a.div(a), 1);
    }

    function testFuzz_div(uint256 a, uint256 b) public {
        vm.assume(b % PRIME != 0);
        uint256 result = mulmod(a, b.inv(), PRIME);
        assertEq(a.div(b), result);
    }
}
