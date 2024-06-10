// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

// Initiate number of campaigns
    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // Check to see if deadline is met
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

// Add the donation to the campaign
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

// Check to see if the amount is added to the campaign
        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

// returns the array of addresses of donators, and the number of donations
    function getDonators(uint256 _id view public return(address[] memory, uint256[] memory)) {
        return(campaigns[_id].donators, campaigns[_id].donations);
    }

// Create a nre variable allCampaigns which is type of array of multiple campaign structures. In this case
// we are not actually getting campaigns, rather, we are just creating an empty array with as many empty elements as ther are actual cmapaigns.
    function getCampaigns() public view returns (campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i=0; i<numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

// Fetch the specific campaign from storage and populating it strtaight to allCampaigns
            allCampaigns[i] = item;
    }

    return allCampaigns;
}