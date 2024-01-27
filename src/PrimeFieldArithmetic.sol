// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title PrimeFieldArithmetic
/// @notice Library for performing arithmetic operations in a prime field
/// @author Diego (0xfuturistic@pm.me)
library PrimeFieldArithmetic {
    /// @notice The prime number from the secp256k1 curve is used.
    uint256 constant PRIME = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    modifier mustBeInField(uint256 value) {
        require(value < PRIME, "value must be in finite field");
        _;
    }

    /// @notice Adds two numbers in the prime field
    /// @param a The first number to add
    /// @param b The second number to add
    /// @return The sum of a and b in the prime field
    function add(uint256 a, uint256 b) internal pure mustBeInField(a) mustBeInField(b) returns (uint256) {
        return addmod(a, b, PRIME);
    }
}
