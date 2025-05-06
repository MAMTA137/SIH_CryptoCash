import 'dart:typed_data';

import 'package:blockchain_upi/services/createWallet.dart';
import 'package:blockchain_upi/testing/abi.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  bool loading = true;

  @override
  void initState() {
    getUserName();

    super.initState();
  }

  void getData() async {
    final apiUrl = "http://192.168.0.107:7545";
    final httpClient = Client();
    final ethClient = Web3Client(apiUrl, httpClient);

    final credentials = EthPrivateKey.fromHex(
        "0x349e80797dc75cc1cd90045d33126436764402777b97ab874e03b5a960e36094");
    final address = credentials.address;

    EtherAmount balanceBefore = await ethClient.getBalance(address);
    print(
        'Balance before transaction: ${balanceBefore.getValueInUnit(EtherUnit.ether)} ETH');

    setState(() {
      loading = false;
    });

    const gasPriceInGwei = 50;
    final gasPrice = EtherAmount.inWei(BigInt.from(gasPriceInGwei * 10 ^ 9));

    final t = await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(
            '0xE771A4392Cb3876Be521000873d4D508922Cec29'),
        gasPrice: gasPrice,
        maxFeePerGas: EtherAmount.fromInt(EtherUnit.gwei, 50),
        value: EtherAmount.fromBase10String(EtherUnit.ether, "1"),
      ),
      chainId: 1337,
    );

    print(t);

    setState(() {
      loading = false;
    });
  }

  void createAccount() async {
    final apiUrl = "http://192.168.0.107:7545";
    final httpClient = Client();
    final ethClient = Web3Client(apiUrl, httpClient);

    final nme = WalletProvider().generateMnemonic();
    final pri = await WalletProvider().getPrivateKey(nme);

    final private_key_obj = EthPrivateKey.fromHex(pri);

    print("pri : $pri");
    print("pri (Hex): ${bytesToHex(private_key_obj.privateKey)}");

    final credentials = EthPrivateKey.fromHex(
        "0x349e80797dc75cc1cd90045d33126436764402777b97ab874e03b5a960e36094");

    final b1 = await ethClient.getBalance(private_key_obj.address);

    print("Balance of new account : ${b1.getInEther}");

    const gasPriceInGwei = 50;
    final gasPrice = EtherAmount.inWei(BigInt.from(gasPriceInGwei * 10 ^ 9));

    final t = await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: private_key_obj.address,
        gasPrice: gasPrice,
        maxFeePerGas: EtherAmount.fromInt(EtherUnit.gwei, 50),
        value: EtherAmount.fromBase10String(EtherUnit.ether, "1"),
      ),
      chainId: 1337,
    );

    print(t);

    final bal = await ethClient.getBalance(private_key_obj.address);

    print("Balance of new account after : ${bal.getInEther}");

    // final d = EthPrivateKey.createRandom(random)

    setState(() {
      loading = false;
    });
  }

  void testContract() async {
    var apiUrl = "http://192.168.0.107:7545"; // Your Ethereum node (Ganache)
    var httpClient = Client();
    var ethClient = Web3Client(apiUrl, httpClient);

    final EthereumAddress contractAddress =
        EthereumAddress.fromHex("0xd67aA8e367cCB2f32E51DB1a7e99F30E11219273");
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

    final addTranFunc = contract.function("addTransaction");

    final sender =
        EthereumAddress.fromHex("0x78d76e40658236e8b1055A0d19182c1a98cd842B");
    final receiver =
        EthereumAddress.fromHex("0x2a84e7841ef92d5863c61c479dc12b947f7b9395");

    String txHash =
        "0x9601a6029116341fd62ad62ae4cf726f6af644573db2b14b35207aedfe965573";
    txHash = txHash.replaceFirst("0x", "");

    List<int> txHashBytes = hex.decode(txHash);

    final etherAmount =
        EtherAmount.fromBase10String(EtherUnit.ether, "1").getInWei;
    final credentials = EthPrivateKey.fromHex(
        "0xf93e0d7900b38713c2cf8bdd4cbc75393d59d388e2a4c40d597a41638627c5ae"); // Replace with actual private key

    const gasPriceInGwei = 50;
    final gasPrice = EtherAmount.inWei(BigInt.from(gasPriceInGwei * 10 ^ 9));

    // final transaction = Transaction.callContract(
    //   contract: contract,
    //   function: addTranFunc,
    //   parameters: [
    //     txHashBytes,
    //     sender,
    //     receiver,
    //     etherAmount,
    //     "Jitesh Gogia",
    //     DateTime.now().toString(), // Date
    //   ],
    //   gasPrice: gasPrice,
    // );

    // // Send the transaction
    // try {
    //   final txHash = await ethClient.sendTransaction(
    //     credentials,
    //     transaction,
    //     chainId: 1337,
    //   );
    //   print("Transaction hash: $txHash");
    // } catch (e) {
    //   print("Error sending transaction: $e");
    // }

    // Optionally: Query the transactions
    final getAllTransactionsForAccount =
        contract.function("getAllTransactionsForAccount");
    final ownAdd =
        EthereumAddress.fromHex("0x78d76e40658236e8b1055A0d19182c1a98cd842B");

    final t = await ethClient.call(
      contract: contract,
      function: getAllTransactionsForAccount,
      params: [ownAdd],
    );
    print("Transactions for account: ${t[0][0][2]}");

    setState(() {
      loading = false;
    });
  }

  void getUserName() async {
    var apiUrl = "http://192.168.0.107:7545"; // Your Ethereum node (Ganache)
    var httpClient = Client();
    var ethClient = Web3Client(apiUrl, httpClient);

    final EthereumAddress contractAddress =
        EthereumAddress.fromHex("0xd67aA8e367cCB2f32E51DB1a7e99F30E11219273");
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

    final getUserName = contract.function("getUserDetails");

    final user =
        EthereumAddress.fromHex("0x4f28054bd4d12c7d7d555cc3a91c9c524b8b04d5");

    final d = await ethClient
        .call(contract: contract, function: getUserName, params: [user]);

    print(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Center(
              child: Text("Transaction Completed!"),
            ),
    );
  }
}
