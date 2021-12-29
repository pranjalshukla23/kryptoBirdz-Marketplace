// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './SafeMath.sol';

library Counters {

    //use A for B , A-> library , B -> data type to use in
    using SafeMath for uint256;

    //build your own variable type with the keyword struct
    struct Counter {

        uint256 _value;

    }

    //we want to find the current value of a count
    //we are using storage keyword to make sure data is not erased
    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    //decrement
    //we are using storage keyword to make sure data is not erased
    function decrement(Counter storage counter) internal {

        //x -> counter._value , y -> 1
        counter._value = counter._value.subtract(1);
    }

    //increment
    //we are using storage keyword to make sure data is not erased
    function increment(Counter storage counter) internal {

        //x -> counter._value , y -> 1
        counter._value += 1;
    }


}

