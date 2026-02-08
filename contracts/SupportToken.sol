// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SupportToken is ERC20, Ownable {
    mapping(address => bool) public minters;

    constructor() ERC20("SupportToken", "SUP") Ownable(msg.sender) {}

    function setMinter(address minter, bool enabled) external onlyOwner {
        minters[minter] = enabled;
    }

    function mint(address to, uint256 amount) external {
        require(minters[msg.sender], "Not minter");
        _mint(to, amount);
    }
}
