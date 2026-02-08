// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISupportToken {
    function mint(address to, uint256 amount) external;
}

contract StartupBooster {
    struct Campaign {
        address creator;
        string title;
        uint256 goalWei;
        uint256 deadline;
        uint256 raisedWei;
        bool finalized;
    }

    ISupportToken public token;
    uint256 public campaignCount;

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;

    uint256 public constant TOKENS_PER_ETH = 100;

    event CampaignCreated(uint256 indexed id, address indexed creator, string title, uint256 goalWei, uint256 deadline);
    event Contributed(uint256 indexed id, address indexed contributor, uint256 amountWei, uint256 tokenAmount);
    event Finalized(uint256 indexed id, bool goalReached);

    constructor(address tokenAddress) {
        token = ISupportToken(tokenAddress);
    }

    function createCampaign(string calldata title, uint256 goalWei, uint256 durationSeconds) external returns (uint256) {
        require(bytes(title).length > 0, "Empty title");
        require(goalWei > 0, "Goal=0");
        require(durationSeconds > 0, "Duration=0");

        campaignCount += 1;
        uint256 id = campaignCount;

        campaigns[id] = Campaign({
            creator: msg.sender,
            title: title,
            goalWei: goalWei,
            deadline: block.timestamp + durationSeconds,
            raisedWei: 0,
            finalized: false
        });

        emit CampaignCreated(id, msg.sender, title, goalWei, block.timestamp + durationSeconds);
        return id;
    }

    function contribute(uint256 id) external payable {
        Campaign storage c = campaigns[id];
        require(c.creator != address(0), "Not found");
        require(block.timestamp < c.deadline, "Ended");
        require(!c.finalized, "Finalized");
        require(msg.value > 0, "Value=0");

        c.raisedWei += msg.value;
        contributions[id][msg.sender] += msg.value;

        uint256 tokenAmount = msg.value * TOKENS_PER_ETH;
        token.mint(msg.sender, tokenAmount);

        emit Contributed(id, msg.sender, msg.value, tokenAmount);
    }

    function finalize(uint256 id) external {
        Campaign storage c = campaigns[id];
        require(c.creator != address(0), "Not found");
        require(!c.finalized, "Finalized");
        require(block.timestamp >= c.deadline, "Too early");

        c.finalized = true;

        bool goalReached = c.raisedWei >= c.goalWei;
        if (goalReached) {
            (bool ok, ) = c.creator.call{value: c.raisedWei}("");
            require(ok, "Transfer failed");
        }

        emit Finalized(id, goalReached);
    }
}
