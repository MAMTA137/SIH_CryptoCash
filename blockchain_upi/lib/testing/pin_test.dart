import 'package:blockchain_upi/testing/abi.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as eth;
import 'package:http/http.dart' as http;

class PinTest extends StatefulWidget {
  const PinTest({super.key});

  @override
  State<PinTest> createState() => _PinTestState();
}

class _PinTestState extends State<PinTest> {
  bool loading = true;

  Future<String> getApiLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiLink = prefs.getString("ip_address") ?? "";
    return "http://192.168.0.111:7545";
  }

  @override
  void initState() {
    tt();

    super.initState();
  }

  // void getData() async {
  //   // final get
  //   String apiUrl = await getApiLink();
  //   var httpClient = http.Client();
  //   var ethClient = eth.Web3Client(apiUrl, httpClient);

  //   final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
  //       "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c");
  //   final contract = eth.DeployedContract(
  //     eth.ContractAbi.fromJson(abi, "UserRegistry"),
  //     contractAddress,
  //   );

  //   final eth.EthereumAddress user = eth.EthereumAddress.fromHex(
  //       "0xd883B6eEc11eAa2308d34AE0da529ACeAD5Ff960");

  //   final getPinFunction = contract.function("getPin");

  //   final tx = await ethClient
  //       .call(contract: contract, function: getPinFunction, params: [user]);

  //   print(tx);

  //   setState(() {
  //     loading = false;
  //   });
  // }

  // // String enc(String pin, String pvtKey) {
  // //   // Initialize the cipher

  // //   String p = "";

  // //   for (var i = 0; i < 32; i++) {
  // //     p += pvtKey[i];
  // //   }

  // //   final cipher = AESCBCCipher();
  // //   cipher.init(key: p, iv: '1234567890123456');

  // //   print(p);

  // //   final encryptedText = cipher.encrypt(pin);

  // //   print("enc  $encryptedText");

  // //   return encryptedText;
  // //   // print("Encrypted Text: $encryptedText");

  // //   // // Decryption
  // //   // print("Decrypting '$encryptedText'...");
  // //   // final decryptedText = cipher.decrypt(encryptedText);

  // //   // // Delayed result to simulate async processing
  // //   // Future.delayed(
  // //   //   const Duration(seconds: 2),
  // //   //       () {
  // //   //     print("Decrypted Text: $decryptedText");
  // //   //   },
  // //   // );
  // //   // if(plainText == decryptedText) {
  // //   //   print("Same hai");
  // //   // }else {
  // //   //   print("Same nahi hai");
  // //   // }
  // // }

  // void setData() async {
  //   String apiUrl = await getApiLink();

  //   final httpClient = http.Client();
  //   final ethClient = eth.Web3Client(apiUrl, httpClient);
  //   final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
  //       "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c");
  //   final contract = eth.DeployedContract(
  //       eth.ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

  //   final setFunction = contract.function("setPin");

  //   final pin = "123456";

  //   String pvtKey =
  //       "0xf93e0d7900b38713c2cf8bdd4cbc75393d59d388e2a4c40d597a41638627c5ae"
  //           .substring(2);

  //   final encPin = "enc(pin, pvtKey)";

  //   final user = eth.EthereumAddress.fromHex(
  //       "0xd883B6eEc11eAa2308d34AE0da529ACeAD5Ff960");

  //   final tx = eth.Transaction.callContract(
  //     contract: contract,
  //     function: setFunction,
  //     parameters: [user, encPin],
  //   );

  //   final credentialsAdmin = eth.EthPrivateKey.fromHex(
  //       "0x71da4b0b4be0405e590b0b30b0249b101b6318a41107f138d592e51f2fab0062");

  //   await ethClient.sendTransaction(credentialsAdmin, tx, chainId: 1337);

  //   for (var i = 0; i < 10; i++) {
  //     print("yyy $i");
  //   }

  //   getData();
  // }

  void tt() {
    final plainText = '123456';
    String p = "";
    String pvt =
        "0xf93e0d7900b38713c2cf8bdd4cbc75393d59d388e2a4c40d597a41638627c5ae";

    // for (var i = 2; i < 34; i++) {
    //   p += pvt[i];
    // }
    // final key = enc.Key.fromUtf8(p);
    // final iv = enc.IV.fromUtf8('1234567890123456');

    // final encrypter = enc.Encrypter(enc.AES(key));

    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);

    // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    // print(encrypted.base64);

    for (var i = 0; i < 10; i++) {
      print(encrypt("123456", pvt));
    }

    setState(() {
      loading = false;
    });
  }

  String encrypt(String pin, String pvtKey) {
    // Initialize the cipher
    String p = "";

    for (var i = 2; i < 34; i++) {
      p += pvtKey[i];
    }

    final key = enc.Key.fromUtf8(p);
    final iv = enc.IV.fromUtf8('1234567890123456');

    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encrypt(pin, iv: iv);

    return encrypted.base64;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Text("data"),
            ),
    );
  }
}
