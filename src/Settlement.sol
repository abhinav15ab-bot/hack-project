// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Settlement is ReentrancyGuard {

    IERC20 public stablecoin;
    address public backend;

    mapping(address => uint256) public balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event TradeSettled(
        uint256 indexed orderId,
        address indexed buyer,
        address indexed seller,
        uint256 amount
    );

    modifier onlyBackend() {
        require(msg.sender == backend, "Not authorized");
        _;
    }

    constructor(address _stablecoin) {
        stablecoin = IERC20(_stablecoin);
        backend = msg.sender; // deployer becomes backend
    }

    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");

        stablecoin.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;

        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        stablecoin.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    function settleTrade(
        uint256 orderId,
        address buyer,
        address seller,
        uint256 amount
    ) external onlyBackend {

        require(balances[buyer] >= amount, "Buyer insufficient balance");

        balances[buyer] -= amount;
        balances[seller] += amount;

        emit TradeSettled(orderId, buyer, seller, amount);
    }
}
