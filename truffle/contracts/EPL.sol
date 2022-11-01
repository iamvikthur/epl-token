// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EPL is IERC20 {
    string public name = "New Club Cat";
    string public symbol = "NCC";
    uint public decimals = 0;
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;
    mapping(address => mapping(address=>uint)) allowances;

    constructor() {
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address _address) public view override returns (uint balance) {
        return balances[_address];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool success) {
        require(balances[msg.sender] >= amount);

        balances[to] += amount;
        balances[msg.sender] -= amount;

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function approve(address spender, uint256 amount) public override  returns (bool) {
        require(balances[msg.sender] >= amount);
        require(amount > 0);

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowances[owner][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(allowances[from][msg.sender] >= amount);
        require(balances[from] >= amount);

        balances[from] -= amount;
        allowances[from][msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
        return  true;
    }

}