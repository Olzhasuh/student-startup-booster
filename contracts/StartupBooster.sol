// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISupportToken {
    function mint(address to, uint256 amount) external;
}

contract StartupBooster {
    struct Campaign {
        address creator;
        string title;
        uint256 goal;
        uint256 deadline;
        uint256 pledged;
    }

    ISupportToken public token;

    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;

    constructor(address tokenAddress) {
        token = ISupportToken(tokenAddress);
    }

    function createCampaign(
        string calldata title,
        uint256 goal,
        uint256 duration
    ) external {
        require(goal > 0, "Goal must be > 0");
        require(duration > 0, "Duration must be > 0");

        campaignCount++;

        campaigns[campaignCount] = Campaign(
            msg.sender,
            title,
            goal,
            block.timestamp + duration,
            0
        );
    }
}
