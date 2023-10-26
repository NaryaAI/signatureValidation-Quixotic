pragma solidity ^0.8.10;

contract NFTContract {
    function supportsInterface(bytes4 x) public returns(bool){
        if(x == 0x01ffc9a7){
            return true;
        }else if(x == 0xffffffff){
            return false;
        }else if(x == 0x80ac58cd){
            return false;
        }else if(x == 0xd9b67a26){
            return true;
        }
    }

    function isApprovedForAll(address, address) public returns(bool){
        return true;
    }

    function transferFrom(address, address, uint256) public returns(bool){
        return true;
    }
    
    function safeTransferFrom(address, address, uint256, uint256, bytes memory) public returns(bool){
        return true;
    }
}