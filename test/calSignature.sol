pragma solidity ^0.8.0;

import "./utils.sol";

contract calSignature {
    bytes32 private EIP712_DOMAIN_TYPE_HASH = keccak256("EIP712Domain(string name,string version)");
    bytes32 private DOMAIN_SEPARATOR = keccak256(abi.encode(
            EIP712_DOMAIN_TYPE_HASH,
            keccak256(bytes("Quixotic")),
            keccak256(bytes("4"))
        ));

    function _validateSellerSignature() public view returns (bytes32) {

        bytes32 SELLORDER_TYPEHASH = keccak256(
            "SellOrder(address seller,address contractAddress,uint256 tokenId,uint256 startTime,uint256 expiration,uint256 price,uint256 quantity,uint256 createdAtBlockNumber,address paymentERC20)"
        );

        bytes32 structHash = keccak256(abi.encode(
                bytes32(SELLORDER_TYPEHASH),
                address(0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e),//sellOrder.seller,
                address(0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f),//sellOrder.contractAddress,
                uint256(1),//sellOrder.tokenId,
                uint256(1),//sellOrder.startTime,
                uint256(9999999999999999999999999999999999999999),//sellOrder.expiration,
                uint256(2736191871050436050944),//sellOrder.price, // 我们通过op.balanceOf得到的
                uint256(1),//sellOrder.quantity,
                uint256(1),//sellOrder.createdAtBlockNumber,
                address(0x4200000000000000000000000000000000000042)//sellOrder.paymentERC20
            ));

        bytes32 digest = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR, structHash);
        // 我需要做的是：用私钥对digest进行签名:
        return digest; // 0xfcbcbc280d251a242fa4dcde6ed925b544f76b504a68bc02ec49171c0e6bc963
        // 然后得到签名
        //      chain=Chain(config.optimismAPI)
        //      account=Account(chain,"97154a62cd5641a577e092d2eee7e39fcb3333dc595371a4303417dae0c2c006")
        //      account.SignMessageHash("0xfcbcbc280d251a242fa4dcde6ed925b544f76b504a68bc02ec49171c0e6bc963")
        //      signature= 0xf39b078814b22a5fc0a3afd98485786acd332e1cc1bd7bc349b98dffafeb431c626776d5a6df000c4650b6e6364fb4097ad71f02c2c46134154820a65f4f77781b
    }

}