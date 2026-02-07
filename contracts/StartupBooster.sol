// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StartupBooster {
    struct Campaign {
        address creator;
        string title;
        uint256 goal;
        uint256 deadline;
    }

    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;

    function createCampaign(string calldata title, uint256 goal, uint256 duration) external {
        require(goal > 0);
        require(duration > 0);

        campaignCount++;

        campaigns[campaignCount] = Campaign(
            msg.sender,
            title,
            goal,
            block.timestamp + duration
        );
    }
}
