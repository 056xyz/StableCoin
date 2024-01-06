// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Decentralized Stable Coin
 * @author abgnv
 * Collateral: Exogenous(ETH & BTC)
 * Minting: Algorithmic
 * Relative Stability: Pegged to 1 USD
 *
 * @dev This contract is meant to be governed by DSCEngine.sol. this contract is just ERC20 implementation of the stablecoin system.
 */
contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin__MustBeMoreThanZero(uint256 _amount);
    error DecentralizedStableCoin__NotZeroAddress();
    error DecentralizedStableCoin__BurnAmountExceedsBalannce(uint256 balance, uint256 _amount);

    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(msg.sender) {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero(_amount);
        }

        if (balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalannce(balance, _amount);
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero(_amount);
        }
        _mint(_to, _amount);
        return true;
    }
}
