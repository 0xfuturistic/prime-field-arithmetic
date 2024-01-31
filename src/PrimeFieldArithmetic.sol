// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title PrimeFieldArithmetic
/// @notice Library for performing arithmetic operations in a prime field
/// @author Diego (0xfuturistic@pm.me)
library PrimeFieldArithmetic {
    /// @notice The prime number from the secp256k1 curve is used.
    uint256 constant PRIME = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    /// @notice Adds two numbers in the prime field
    /// @param a The first number to add
    /// @param b The second number to add
    /// @return The sum of a and b in the prime field
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return addmod(a, b, PRIME);
    }

    /// @notice Subtracts one number from another in the prime field
    /// @param a The number to subtract from
    /// @param b The number to subtract
    /// @return The result of subtracting b from a in the prime field
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return add(a, PRIME - (b % PRIME));
    }

    /// @notice Multiplies two numbers in the prime field
    /// @param a The first number to multiply
    /// @param b The second number to multiply
    /// @return The product of a and b in the prime field
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return mulmod(a, b, PRIME);
    }

    /// @notice Efficiently performs modular exponentiation in a prime field.
    ///         Utilizes the square-and-multiply algorithm, optimized for Solidity.
    /// @param base The base number
    /// @param exponent The exponent
    /// @return result The result of base^exponent mod PRIME.
    function exp(uint256 base, uint256 exponent) internal pure returns (uint256 result) {
        result = 1; // Initialize result as 1, as any number to the power of 0 is 1.
        base %= PRIME; // Ensures base is within field limits.
        // Iterate over each bit of the exponent, starting from the least significant bit.
        while (exponent != 0) {
            // If the current bit is set, multiply the result by the base, modulo PRIME.
            if (exponent & 1 != 0) {
                result = mulmod(result, base, PRIME);
            }
            base = mulmod(base, base, PRIME); // Square the base for the next bit, modulo PRIME.
            exponent >>= 1; // Right shift exponent by 1 bit (equivalent to floor division by 2).
        }
    }

    /// @notice Calculates the modular multiplicative inverse of a number a modulo p using the formula  a^(p-2) mod p.
    ///         This is based on Fermat's Little Theorem, which states that  a^(p-1) ≡ 1 mod p for any non-zero a in a field of size p.
    /// @param a The number to calculate the inverse of
    /// @return The modular multiplicative inverse of a in the prime field
    function inv(uint256 a) internal pure returns (uint256) {
        require(a % PRIME != 0, "cannot divide by zero");
        return exp(a, PRIME - 2);
    }

    /// @notice Divides one number, the numerator, by another, the divisor, in the prime field.
    /// @param numerator The number to divide
    /// @param divisor The number to divide by
    /// @return The result of dividing a by b in the prime field
    function div(uint256 numerator, uint256 divisor) internal pure returns (uint256) {
        return mul(numerator, inv(divisor));
    }
}
