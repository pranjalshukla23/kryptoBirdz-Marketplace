// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    //build functions to perform safe math operations
    //that would replace intuitive measures

    //function add r = x + y
    function add(uint256 x, uint256 y) internal pure returns (uint256){
        uint256 r = x + y;
        require(r >= x, 'SafeMath Addition Overflow');
        return r;
    }

    //function subtraction r = x - y
    function subtract(uint256 x, uint256 y) internal pure returns (uint256){
        require(y <= x, 'SafeMath Subtraction Overflow');
        uint256 r = x - y;
        return r;
    }

    //write an internally visible multiply function which ensures
    //no remaining multiplication overflow using the r = x * y equation
    //function multiply r = x * y
    // gas optimization
    function multiply(uint256 x, uint256 y) internal pure returns (uint256){
        //gas optimization
        if (x == 0) {
            return 0;
        }
        uint256 r = x * y;
        require(r / x == y, 'SafeMath Multiplication Overflow');
        return r;
    }

    //solidity only automatically asserts when dividing by zero
    //write an internally visible divide function which requires that y is always greater than zero
    //within the equation r = x / y
    function divide(uint256 x, uint256 y) internal pure returns (uint256){

        require(y > 0, 'SafeMath Division Overflow');
        uint256 r = x / y;
        return r;
    }
    //write a modulo function which requires that y does not equal zero under any circumstance
    //return the modulo of the equation from r = x % y
    function modulo(uint256 x, uint256 y) internal pure returns (uint256){

        //gas spending remains untouched
        require(y != 0, 'SafeMath Module Overflow');
        uint256 r = x % y;
        return r;
    }


}
