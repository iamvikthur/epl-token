// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EPL.sol";

contract EPLICO is EPL {
    address public admin;
    address payable public depositAddress;
    uint public tokenPrice = 0.001 ether; // 1ETH = 1000 EPL, 1EPL = 0.001ETH
    uint public hardcap = 300 ether;
    uint public raisedAmount;
    uint public saleStart = block.timestamp; //to start at a later time, add the number of seconds to block.timestamp
    uint public saleEnd = block.timestamp + 604800; //ico ends in a week
    uint public tokenTradeStart = saleEnd + 604800; // token is transferable in a week after end of token sale;
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;

    constructor(address payable _depositAddress) {
        depositAddress = _depositAddress;
        admin = msg.sender;
        icoState = State.beforeStart;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    function halt() public onlyAdmin {
        icoState = State.halted;
    }

    function resume() public onlyAdmin {
        icoState = State.running;
    }

    function changeDepositeAddress(address payable _newDeposteAddress) public onlyAdmin {
        depositAddress = _newDeposteAddress;
    }

    function getCurrentState() public view returns(State _icoState) {
        // return icoState;
        if (icoState == State.halted) {
            return State.halted;
        } else if (block.timestamp < saleStart) {
            return State.beforeStart;
        } else if (block.timestamp >= saleStart && block.timestamp <= saleEnd) {
            return State.running;
        } else {
            return State.afterEnd;
        }
    }

    event Invest(address investor, uint value, uint tokens);

    function invest() payable public returns(bool) {
        icoState = getCurrentState();
        require(icoState == State.running);
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        require(raisedAmount <= hardcap);

        // calculate number of tokens user will get
        uint tokens = msg.value / tokenPrice;

        balances[msg.sender] += tokens;
        balances[founder] -= tokens;

        depositAddress.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokens);

        return true;
    }

    receive() payable external {
        invest();
    }

    function transfer(address to, uint256 amount) public override returns (bool success) {
        require(block.timestamp >= tokenTradeStart);
        super.transfer(to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(block.timestamp >= tokenTradeStart);
        super.transferFrom(from, to, amount);

        return true;
    }

    function burn() public returns(bool) {
        icoState = getCurrentState();
        require(icoState == State.afterEnd);

        balances[founder] = 0;

        return true;
    }
}