import 'dart:convert';
import 'package:blockchain_upi/models/get_home_data.dart';
import 'package:blockchain_upi/testing/abi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as eth;
import 'dart:io';
import '../main.dart';

class HttpApiCalls {
  Future<String> getApiLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiLink = prefs.getString("ip_address") ?? "";
    return "http://192.168.0.111:7545";
  }

  final master = eth.EthPrivateKey.fromHex(
      "0x36f6742ef6cb3b8ba8634c8818a76a32bc07f72a48fa86d756155c112e0f360b");
  final contractString = "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c";

  // Analysis

  Future<String> getAnalysis(Map<String, dynamic> data) async {
    for (var i = 0; i < 10; i++) {
      print("function called $i");
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.111:5000/get_analysis'));

    // Add the 'reason' field to the form data
    request.fields.addAll({
      'reason': data['tx_name'],
    });

    // Send the request and get the response
    http.StreamedResponse response = await request.send();

    // Convert the response to a regular HTTP response
    var responsedata = await http.Response.fromStream(response);

    String analysis = "others"; // Default value if something goes wrong

    // Check if the response was successful
    if (responsedata.statusCode == 200) {
      // Decode the JSON response
      final map = json.decode(responsedata.body);
      // Extract the 'analysis' field from the JSON response
      analysis = map['analysis'] ?? 'others';
    } else {
      print('Error: ${responsedata.statusCode}, ${responsedata.body}');
    }

    return analysis;
  }

  //Perform Transaction
  Future<Map<String, dynamic>> transaction(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    print("idhar pohocha kya?");
    final httpClient = http.Client();
    final ethClient = eth.Web3Client(apiUrl, httpClient);

    final eth.EthereumAddress contractAddress =
        eth.EthereumAddress.fromHex(contractString);
    final contract = eth.DeployedContract(
        eth.ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

    final addTranFunc = contract.function("addTransaction");

    final sender = eth.EthereumAddress.fromHex(data["acc1"]);
    final receiver = eth.EthereumAddress.fromHex(data['acc2']);
    final receiverUPI = data["upi_address"];

    // final etherAmount = eth.EtherAmount.inWei(
    //   BigInt.from((data['eth'] as double) / (data['rate'] as double) * (10e17)),
    // );

    Decimal bruteForcePow(Decimal base, int exponent) {
      Decimal result = Decimal.one;
      for (int i = 0; i < exponent; i++) result *= base;
      return result;
    }

    Decimal result = Decimal.parse(data['eth']);
    Decimal weiValue = bruteForcePow(Decimal.fromInt(10), 18) * result;

    final etherAmount = eth.EtherAmount.fromBigInt(
      eth.EtherUnit.wei,
      weiValue.toBigInt(),
    );

    for (var i = 0; i < 10; i++) {
      print(etherAmount.getValueInUnit(eth.EtherUnit.ether));
    }
    final credentials = eth.EthPrivateKey.fromHex(data['p1']);

    const gasPriceInGwei = 50;
    final gasPrice =
        eth.EtherAmount.inWei(BigInt.from(gasPriceInGwei * 10 ^ 9));

    final txhash = await ethClient.sendTransaction(
      credentials,
      eth.Transaction(
        from: sender,
        to: receiver,
        gasPrice: gasPrice,
        value: etherAmount,
      ),
      chainId: 1337,
    );
    print("idhar aya?");
    final txHashBytes = hexToBytes(txhash);

    final transaction = eth.Transaction.callContract(
      contract: contract,
      function: addTranFunc,
      parameters: [
        txHashBytes,
        sender,
        receiver,
        etherAmount.getInWei,
        data['tx_name'],
        DateTime.now().toString(),
        true,
        receiverUPI, // Date
      ],
      gasPrice: gasPrice,
    );

    await ethClient.sendTransaction(
      credentials,
      transaction,
      chainId: 1337,
    );

    print("Transaction started.");
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.111:4000/transfer-funds'));

    print({
      'payee_id': receiverUPI,
      'amount': data['inr'].toString(),
    });

// Add the fields to the request
    request.fields.addAll({
      'payee_id': receiverUPI,
      'amount': data['inr'].toString(),
    });

    request.headers.addAll({
      'Content-Type': 'application/json',
    });

// Send the request and get the response
    http.StreamedResponse response = await request.send();

// Convert the response to a regular HTTP response
    var responsedata = await http.Response.fromStream(response);

    print(responsedata.body);
    print("Transaction done.");

    String analysis = await getAnalysis(data);

    for (var i = 0; i < 10; i++) {
      print("ans : $analysis");
    }

    //Analysis
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(data['acc1']);
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        int currentCount = userData[analysis] ?? 0;

        for (var i = 0; i < 10; i++) {
          print("currentt trsan $currentCount");
        }
        transaction.update(userRef, {analysis: currentCount + 1});
      } else {
        for (var i = 0; i < 10; i++) {
          print("10 : $i");
        }
      }
    });

    return {'message': 'Transaction Succeessful'};
  }

  // Make Account
  Future<Map<String, dynamic>> makeAccount(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    String? fileName = data['fileName'];
    File imageFile = data['imageFile'];
    print(
      "Filename: ${data['fileName']}",
    );
    print("ImageFile: ${data['imageFile']}");

    print("api $apiUrl");

    final httpClient = http.Client();
    final ethClient = eth.Web3Client(apiUrl, httpClient);

    print("connected");

    final eth.EthereumAddress contractAddress =
        eth.EthereumAddress.fromHex(contractString);
    final contract = eth.DeployedContract(
        eth.ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);
    print("Contract done");

    final etherAmount =
        eth.EtherAmount.fromBase10String(eth.EtherUnit.ether, "100");

    final newUser = eth.EthPrivateKey.fromHex(data['pri_key']);
    print("new user");
    dynamic userData = {
      'public_address': newUser.address.toString(),
      'user_name': data['name'],
      'user_image': "idhar_image_url_badme_ayega",
      'is_kyc_done': false
    };
    await Supabase.instance.client.from('UserProfile').insert(userData);
    // await Supabase.instance.client.from('UserProfile').insert({
    //   'public_address': "0xd883b6eec11eaa2308d34ae0da529acead5ff960",
    //   'user_name': "Pooja G",
    //   'user_image':
    //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQsKJMJf8R-IjSyL2ft9eiU4GeopyDH-WJlA&s",
    //   'is_kyc_done': false
    // });
    print("After supabase");

    final uploadResponse = await supaBase.storage
        .from('profileImages')
        .upload(fileName!, imageFile);

    final String publicUrl =
        supaBase.storage.from('profileImages').getPublicUrl(fileName);

    print('Image uploaded successfully!');

    final result = await Supabase.instance.client
        .from('UserProfile')
        .select('id')
        .eq('public_address', newUser.address.toString())
        .single();

    final userId = result['id'];
    print('User ID: $userId');

    final data1 = {
      'id': userId,
      'user_image': publicUrl,
    };

    final response =
        await Supabase.instance.client.from('UserProfile').upsert(data1);
    print("After image upload response: $response");

    print("new user done");

    const gasPriceInGwei = 50;
    final gasPrice =
        eth.EtherAmount.inWei(BigInt.from(gasPriceInGwei * 10 ^ 9));

    final txhash = await ethClient.sendTransaction(
      master,
      eth.Transaction(
        from: master.address,
        to: newUser.address,
        gasPrice: gasPrice,
        value: etherAmount,
      ),
      chainId: 1337,
    );

    final addTranFunc = contract.function("addTransaction");

    print("Hree fter transaction;");

    final addInitTransaction = eth.Transaction.callContract(
      contract: contract,
      function: addTranFunc,
      parameters: [
        hexToBytes(txhash),
        master.address,
        newUser.address,
        etherAmount.getInWei,
        "Initialize",
        DateTime.now().toString(),
        false,
        "",
      ],
      gasPrice: gasPrice,
    );

    await ethClient.sendTransaction(
      master,
      addInitTransaction,
      chainId: 1337,
    );

    print(" Send the transaction");

    return {
      "address": newUser.address.toString(),
      "private_key": bytesToHex(newUser.privateKey, include0x: true),
      "image": publicUrl,
    };
  }

  Future<Map<String, dynamic>> getUserDetails(
      String address, bool isUpi) async {
    // var apiUrl = await getApiLink();
    // var httpClient = http.Client();
    // var ethClient = eth.Web3Client(apiUrl, httpClient);

    // final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
    //     contractString);
    // final contract = eth.DeployedContract(
    //     eth.ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

    // final getUserName = contract.function("getUserDetails");

    // final user = eth.EthereumAddress.fromHex(address);

    // final d = await ethClient
    //     .call(contract: contract, function: getUserName, params: [user]);

    // return {"username": d[0], "image": d[1]};

    // print(response);

    if (isUpi) {
      return {
        "username": "Pooja Gawade",
        "image":
            "https://edpajkciywgutycdvqxc.supabase.co/storage/v1/object/public/profileImages/1733971747557.jpg"
      };
    }

    final response = await Supabase.instance.client
        .from('UserProfile')
        .select('*')
        .eq('public_address', address)
        .single();

    final userData = {
      "username": response['user_name'],
      "image": response['user_image'],
    };
    // print("object  $address");
    // print(userData);
    return userData;
  }

  Future<String> getUserBalance(String address) async {
    var apiUrl = await getApiLink();
    var httpClient = http.Client();
    var ethClient = eth.Web3Client(apiUrl, httpClient);

    final user = eth.EthereumAddress.fromHex(address);

    final balance = await ethClient.getBalance(user);

    return balance.getInEther.toString();
  }

  Future<HomeModel?> getHomeData(Map<String, dynamic> data) async {
    try {
      String apiUrl = await getApiLink();
      var httpClient = http.Client();
      var ethClient = eth.Web3Client(apiUrl, httpClient);

      final eth.EthereumAddress contractAddress =
          eth.EthereumAddress.fromHex(contractString);
      final contract = eth.DeployedContract(
        eth.ContractAbi.fromJson(abi, "UserRegistry"),
        contractAddress,
      );

      // Fetch user address
      final eth.EthereumAddress user =
          eth.EthereumAddress.fromHex(data['address']);

      // Call getUserDetails for username and other data
      final userDetails = await getUserDetails(
          data['address'], "user1@hdfcbank" == data['address']);

      final username = userDetails[0];

      // Get user balance
      final balance = await ethClient.getBalance(user);
      final balanceInEther =
          balance.getValueInUnit(eth.EtherUnit.ether).toString();

      // Fetch all transactions for the user
      final getAllTransactionsForAccount =
          contract.function("getAllTransactionsForAccount");
      final transactions = await ethClient.call(
        contract: contract,
        function: getAllTransactionsForAccount,
        params: [user],
      );

      // print(transactions);

      List<Map<String, dynamic>> parsedTransactions = [];
      for (var tx in transactions[0]) {
        if (tx == null || tx.length < 5) continue;

        // print(tx[0].toString());
        // print(tx[1].toString());

        final senderDetails = await getUserDetails(tx[0].toString(),
            "0xd883B6eEc11eAa2308d34AE0da529ACeAD5Ff960" == tx[0].toString());

        final receiverDetails = await getUserDetails(tx[1].toString(),
            "0xd883B6eEc11eAa2308d34AE0da529ACeAD5Ff960" == tx[1].toString());

        parsedTransactions.add({
          'from': senderDetails['username'],
          'to': receiverDetails['username'],
          'sender_image': senderDetails['image'],
          'receiver_image': receiverDetails['image'],
          'myself': tx[1].toString() == data['address'],
          'amt': eth.EtherAmount.fromBigInt(eth.EtherUnit.wei, tx[2])
              .getValueInUnit(eth.EtherUnit.ether)
              .toString(),
          'name': tx[3] ?? "Unknown",
          'date': tx[4] ?? "Unknown Date",
        });
      }

      parsedTransactions.sort((a, b) => b['date'].compareTo(a['date']));

      // Create the final map response
      final result = {
        'username': username,
        'balance': balanceInEther,
        'transaction': parsedTransactions,
      };

      // print(result);

      return HomeModel.fromJson(result);
    } catch (e) {
      print("Error in getHomeData: $e");
      return null;
    }
  }

  Future<HomeModel?> getTransactions() async {
    String apiUrl = await getApiLink();
    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl/get_transactions'));

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      // print(responsedata.body);
      return HomeModelFromJson(responsedata.body);
    } else {
      print("Herererer");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<dynamic> getBitcoin() async {
    try {
      print("Called function");

      var response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'),
        headers: {
          'x-cg-demo-api-key': '',
        },
      );

      if (response.statusCode == 200) {
        // print("Inside api call");
        // print(response.body);
        return (response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return {};
      }
    } catch (error) {
      print('Error sending request: $error');
      return {};
    }
  }

  Future<bool> aadhaarVerification(String uid) async {
    try {
      dynamic body = {
        'txn_id': '17c6fa41-778f-49c1-a80a-cfaf7fae2fb8',
        'consent': 'Y',
        'uidnumber': uid,
        'clientid': '222',
        'method': 'uidvalidatev2',
      };

      var response = await http.post(
        Uri.parse(
            'https://verifyaadhaarnumber.p.rapidapi.com/Uidverifywebsvcv1/VerifyAadhaarNumber'),
        headers: {
          'content-type': 'application/x-www-form-urlencoded',
          'X-RapidAPI-Key':
              '',
          'X-RapidAPI-Host': 'verifyaadhaarnumber.p.rapidapi.com',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        if (responseData['Succeeded'] != null &&
            responseData['Succeeded']['Verify_status'] == 'Uid is Valid') {
          return true;
        } else {
          return false;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error sending request: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> buyCoin(Map<String, dynamic> data) async {
    String apiUrl = await getApiLink();
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/buy_coin'));
    request.fields.addAll({
      "acc1": data['acc1'],
      "p1": data['p1'],
      "price": data['price'],
      "tx_name": data['tx_name'],
      "date": data['date'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responsedata.body);

      final response = json.decode(responsedata.body) as Map<String, dynamic>;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(data['acc1']);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          int currentCount = userData[response['analysis']] ?? 0;
          transaction.update(userRef, {response['analysis']: currentCount + 1});
        }
      });
      return response;
    } else {
      print("error in transaction");
      print(response.reasonPhrase);
      return {};
    }
  }
}
