// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

interface ERC20Swapper {
    function swapEtherToToken(address token, uint minAmount) external payable returns (uint);
}

contract EtherToTokenSwapper is ERC20Swapper {
    function swapEtherToToken(address token, uint minAmount) public payable override returns (uint) {
        require(msg.value > 0, "No ether sent");
        require(token != address(0), "Invalid token address");

        ERC20 erc20 = ERC20(token);

        uint balanceBefore = erc20.balanceOf(address(this));
        uint amountToSwap = msg.value;
        erc20.transfer(msg.sender, amountToSwap);
        uint balanceAfter = erc20.balanceOf(address(this));

        require(balanceAfter - balanceBefore >= minAmount, "Minimum token amount not met");

        return balanceAfter - balanceBefore;
    }
}