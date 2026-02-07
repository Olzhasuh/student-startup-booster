// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SupportToken is ERC20, Ownable {
    constructor() ERC20("SupportToken", "SUP") Ownable(msg.sender) {}
}
