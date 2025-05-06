import 'package:blockchain_upi/screens/Payment/payment_success.dart';
import 'package:blockchain_upi/testing/abi.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as eth;
import 'package:http/http.dart' as http;

class confirmScreen extends StatefulWidget {
  @override
  _confirmScreenState createState() => _confirmScreenState();
}

class _confirmScreenState extends State<confirmScreen> {
  final _pinController = TextEditingController();
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

    for (var i = 2; i < 34; i++) {
      p += pvtKey[i];
    }

    final key = enc.Key.fromUtf8(p);
    final iv = enc.IV.fromUtf8('1234567890123456');

    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encrypt(pin, iv: iv);

    return encrypted.base64;
  }

  Future<bool> getData() async {
    String apiUrl = await getApiLink();
    var httpClient = http.Client();
    var ethClient = eth.Web3Client(apiUrl, httpClient);

    final eth.EthereumAddress contractAddress = eth.EthereumAddress.fromHex(
        "0x7439A4f9e2ce0486F966cb27FF1D018Cb02f2a8c");
    final contract = eth.DeployedContract(
      eth.ContractAbi.fromJson(abi, "UserRegistry"),
      contractAddress,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String address = prefs.getString("address") ?? " ";

    final eth.EthereumAddress user = eth.EthereumAddress.fromHex(address);

    final getPinFunction = contract.function("getPin");

    final tx = await ethClient
        .call(contract: contract, function: getPinFunction, params: [user]);

    setState(() {
      loading = false;
    });
    String pvtKey = prefs.getString("private_key") ?? " ";
    final encPin = encrypt(_pinController.text, pvtKey);

    print("object");
    print(tx[0]);
    print(encPin);
    if (tx[0] == encPin) {
      return true;
    } else {
      return false;
    }
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
                SizedBox(height: 32.0),
                Text(
                  'Confirm Your PIN',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Please enter your 6-digit PIN to continue',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                _buildPinInput(),
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
                  onPressed: () async {
                    if (await getData()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PaymentSuccessScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Incorrect PIN. Please try again.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Confirm PIN',
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

  Widget _buildPinInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Enter PIN',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PinCodeTextField(
          controller: _pinController,
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
}
