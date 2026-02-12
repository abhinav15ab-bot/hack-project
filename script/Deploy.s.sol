// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Stablecoin.sol";
import "../src/Settlement.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Stablecoin stablecoin = new Stablecoin();
        Settlement settlement = new Settlement(address(stablecoin));

        vm.stopBroadcast();
    }
}
