// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AbstractCalculator.sol";

contract Calculator is AbstractCalculator {
    struct LastResult {
        uint256 a;
        uint256 b;
        uint256 result;
        string operation;
    }

    mapping(address => LastResult[]) public history;

    event Calculate(uint256 result);

    function calculate(uint256 a, uint256 b, string memory operation) public {
        uint256 _result;

        if (
            keccak256(abi.encodePacked(operation)) ==
            keccak256(abi.encodePacked("add"))
        ) {
            _result = add(a, b);
        } else if (
            keccak256(abi.encodePacked(operation)) ==
            keccak256(abi.encodePacked("subtract"))
        ) {
            _result = subtract(a, b);
        } else if (
            keccak256(abi.encodePacked(operation)) ==
            keccak256(abi.encodePacked("multiply"))
        ) {
            _result = multiply(a, b);
        } else if (
            keccak256(abi.encodePacked(operation)) ==
            keccak256(abi.encodePacked("divide"))
        ) {
            _result = divide(a, b);
        } else {
            revert("Invalid operation");
        }
        history[msg.sender].push(
            LastResult({a: a, b: b, result: _result, operation: operation})
        );
        emit Calculate(_result);
    }

    function getLastResult(
        address user
    ) public view returns (LastResult memory) {
        require(history[user].length > 0, "No calculation history");
        return history[user][history[user].length - 1];
    }

    function getHistoryLength(address user) public view returns (uint256) {
        return history[user].length;
    }

    function getHistoryItem(
        address user
    ) public view returns (LastResult[] memory) {
        require(history[user].length > 0, "No calculation history");
        return history[user];
    }
}
