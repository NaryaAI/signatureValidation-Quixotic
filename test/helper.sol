pragma solidity ^0.8.0;

contract helper{
    function getETHBalance(address _addr) public view returns(uint256){
        return address(_addr).balance;
    }
}