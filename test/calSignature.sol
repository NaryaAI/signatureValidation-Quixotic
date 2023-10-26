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
                address(0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf),//sellOrder.seller,
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
        return digest; // 0xce5f60b81b1d753a9653d31bfe0b00aa861dc1f7b58aeae374d9c0c8d82389e3
        // 然后得到签名
        //      chain=Chain(config.optimismAPI)
        //      account=Account(chain,"0000000000000000000000000000000000000000000000000000000000000001")
        //      account.SignMessageHash("0xce5f60b81b1d753a9653d31bfe0b00aa861dc1f7b58aeae374d9c0c8d82389e3")
        //      signature= 0xed60c44be131f7252ba5b53a3a56ab340a5231c122f454e37fed4302a4ae5568191eee46f491eefd3c0aeb895f9045ded4c55194e204647a78528e34085b9ef81b
    }

}