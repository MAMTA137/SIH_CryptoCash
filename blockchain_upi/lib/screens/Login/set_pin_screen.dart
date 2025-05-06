// import 'package:aes_cbc_cipher/aes_cbc_cipher.dart';
// import 'package:blockchain_upi/screens/Bottom%20nav/bottom_nav.dart';
// import 'package:blockchain_upi/screens/Home/home.dart';
// import 'package:blockchain_upi/testing/abi.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web3dart/web3dart.dart' as eth;
// import 'package:http/http.dart' as http;

// class SetPinScreen extends StatefulWidget {
//   @override
//   _SetPinScreenState createState() => _SetPinScreenState();
// }

// class _SetPinScreenState extends State<SetPinScreen> {
//   final _pinController = TextEditingController();
//   final _confirmPinController = TextEditingController();
//   String _errorMessage = '';
//   bool loading = true;

//   Future<String> getApiLink() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String apiLink = prefs.getString("ip_address") ?? "";
//     return "http://192.168.0.111:7545";
//   }

//   String enc(String pin, String pvtKey) {
//     // Initialize the cipher

//     String p = "";

//     for (var i = 0; i < 32; i++) {
//       p += pvtKey[i];
//     }

//     final cipher = AESCBCCipher();
//     cipher.init(key: p, iv: '1234567890123456');

//     print(p);

//     final encryptedText = cipher.encrypt(pin);

//     print("enc  $encryptedText");

//     return encryptedText;
//   }

//   Future<void> setData() async {
//     String apiUrl = await getApiLink();

//     final httpClient = http.Client();
//     final ethClient = eth.Web3Client(apiUrl, httpClient);
//     final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
//         "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c");
//     final contract = eth.DeployedContract(
//         eth.ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

//     final setFunction = contract.function("setPin");

//     final pin = _confirmPinController.text;
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     String address = prefs.getString("address") ?? " ";
//     String pvtKey = prefs.getString("private_key") ?? " ";
//     pvtKey = pvtKey.substring(2);

//     final encPin = enc(pin, pvtKey);

//     final user = eth.EthereumAddress.fromHex(address);

//     final tx = eth.Transaction.callContract(
//       contract: contract,
//       function: setFunction,
//       parameters: [user, encPin],
//     );

//     final credentialsAdmin = eth.EthPrivateKey.fromHex(
//         "0x71da4b0b4be0405e590b0b30b0249b101b6318a41107f138d592e51f2fab0062");

//     await ethClient.sendTransaction(credentialsAdmin, tx, chainId: 1337);

//     for (var i = 0; i < 10; i++) {
//       print("yyy $i");
//     }

//     // getData();
//   }

//   void getData() async {
//     // final get
//     String apiUrl = await getApiLink();
//     var httpClient = http.Client();
//     var ethClient = eth.Web3Client(apiUrl, httpClient);

//     final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
//         "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c");
//     final contract = eth.DeployedContract(
//       eth.ContractAbi.fromJson(abi, "UserRegistry"),
//       contractAddress,
//     );

//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     String address = prefs.getString("address") ?? " ";

//     final eth.EthereumAddress user = eth.EthereumAddress.fromHex(address);

//     final getPinFunction = contract.function("getPin");

//     final tx = await ethClient
//         .call(contract: contract, function: getPinFunction, params: [user]);

//     print(tx);

//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Set PIN',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 32.0),
//             TextField(
//               controller: _pinController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Enter PIN',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _confirmPinController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Confirm PIN',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             if (_errorMessage.isNotEmpty)
//               Text(
//                 _errorMessage,
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _handleSetPin,
//               child: Text('Set PIN'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Color(0xFF8C79E7),
//                 padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleSetPin() async {
//     final pin = _pinController.text.trim();
//     final confirmPin = _confirmPinController.text.trim();

//     if (pin.isEmpty || confirmPin.isEmpty) {
//       setState(() {
//         _errorMessage = 'Please enter and confirm your PIN.';
//       });
//       return;
//     }

//     if (pin != confirmPin) {
//       setState(() {
//         _errorMessage = 'PIN and Confirmed PIN do not match.';
//       });
//       return;
//     }

//     await setData();

//     print('PIN set: $pin');
//     // Clear the text fields
//     _pinController.clear();
//     _confirmPinController.clear();
//     setState(() {
//       _errorMessage = '';
//     });

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => BottomNavBar(),
//       ),
//     );
//   }
// }

import 'package:blockchain_upi/screens/Bottom%20nav/bottom_nav.dart';
import 'package:blockchain_upi/testing/abi.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as eth;
import 'package:http/http.dart' as http;

class SetPinScreen extends StatefulWidget {
  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String _errorMessage = '';
  bool loading = true;
  bool _obscurePin = true;

  Future<String> getApiLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiLink = prefs.getString("ip_address") ?? "";
    return "http://192.168.0.111:7545";
  }

  String encrypt(String pin, String pvtKey) {
    // Initialize the cipher
    String p = "";
    for (var i = 0; i < 32; i++) {
      p += pvtKey[i];
    }

    final key = enc.Key.fromUtf8(p);
    final iv = enc.IV.fromUtf8('1234567890123456');

    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encrypt(pin, iv: iv);

    print("Encrypted PIN: ${encrypted.base64}");

    return encrypted.base64; // Ensure you're using base64 encoding
  }

  Future<void> setData() async {
    String apiUrl = await getApiLink();

    final httpClient = http.Client();
    final ethClient = eth.Web3Client(apiUrl, httpClient);
    final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
        "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c");
    final contract = eth.DeployedContract(
        eth.ContractAbi.fromJson(abi, "UserRegistry"), contractAddress);

    final setFunction = contract.function("setPin");

    final pin = _confirmPinController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String address = prefs.getString("address") ?? " ";
    String pvtKey = prefs.getString("private_key") ?? " ";
    pvtKey = pvtKey.substring(2);

    final encPin = encrypt(pin, pvtKey);

    final user = eth.EthereumAddress.fromHex(address);

    final tx = eth.Transaction.callContract(
      contract: contract,
      function: setFunction,
      parameters: [user, encPin],
    );

    final credentialsAdmin = eth.EthPrivateKey.fromHex(
        "0x71da4b0b4be0405e590b0b30b0249b101b6318a41107f138d592e51f2fab0062");

    await ethClient.sendTransaction(credentialsAdmin, tx, chainId: 1337);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Set Your PIN',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Create a 6-digit PIN to secure your account',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                _buildPinInput(
                    controller: _pinController,
                    label: 'Enter PIN',
                    isFirst: true),
                SizedBox(height: 16.0),
                _buildPinInput(
                    controller: _confirmPinController,
                    label: 'Confirm PIN',
                    isFirst: false),
                SizedBox(height: 16.0),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _handleSetPin,
                  child: Text(
                    'Set PIN',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF8C79E7),
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinInput(
      {required TextEditingController controller,
      required String label,
      required bool isFirst}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PinCodeTextField(
          controller: controller,
          appContext: context,
          length: 6,
          obscureText: _obscurePin,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8.0),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            activeColor: Color(0xFF8C79E7),
            selectedColor: Color(0xFF8C79E7),
            inactiveColor: Colors.grey.shade300,
          ),
          onChanged: (value) {},
        ),
        if (isFirst)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _obscurePin = !_obscurePin;
                });
              },
              child: Text(
                _obscurePin ? 'Show PIN' : 'Hide PIN',
                style: TextStyle(
                  color: Color(0xFF8C79E7),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleSetPin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (pin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter and confirm your PIN.';
      });
      return;
    }

    if (pin != confirmPin) {
      setState(() {
        _errorMessage = 'PIN and Confirmed PIN do not match.';
      });
      return;
    }

    await setData();

    print('PIN set: $pin');
    // Clear the text fields
    _pinController.clear();
    _confirmPinController.clear();
    setState(() {
      _errorMessage = '';
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BottomNavBar(),
      ),
    );
  }
}
