// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Medicalhelp {
    address public manager;
    address[] public donors;
    uint256 public counter = 0;
    uint256 public upVote = 0;
    uint256 public downVote = 0;

    struct Request {
        uint256 amount;
        address payable patient;
        bool completed;
        uint256 upVoteCount;
        uint256 downVoteCount;
    }

    mapping(address => uint256) public donations;
    mapping(uint256 => Request) public requests;
    event Received(address sender, uint amount);
    event RequestMade(uint256 counter, address patient, uint256 amount);

    constructor(address _manager) {
        manager = _manager;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    function donate() public payable {
        donors.push(msg.sender);
        require(msg.value > 0, "Donation must be greater than 0");
        donations[msg.sender] += msg.value;
        emit Received(msg.sender, msg.value);
    }

    function spendingRequest(
        uint256 amount,
        address payable patient
    ) public onlyManager {
        require(
            amount <= address(this).balance,
            "Insufficient funds in contract"
        );
        counter += 1;
        requests[counter] = Request({
            amount: amount,
            patient: patient,
            completed: false,
            upVoteCount: 0,
            downVoteCount: 0
        });
        emit RequestMade(counter, patient, amount);
    }

    function vote(uint256 requestId, bool approve) public {
        Request storage request = requests[requestId];
        require(!request.completed, "Request already completed");

        if (approve) {
            request.upVoteCount += 1;
        } else {
            request.downVoteCount += 1;
        }
    }

    function finalizeRequest(uint256 requestId) public onlyManager {
        Request storage request = requests[requestId];
        require(!request.completed, "Request already completed");
        require(
            request.upVoteCount > request.downVoteCount,
            "Not enough upvotes"
        );
        request.completed = true;
        (bool success, ) = request.patient.call{value: request.amount}("");
        require(success, "Transfer failed");
    }

    function getDonations(address donor) public view returns (uint256) {
        return donations[donor];
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
