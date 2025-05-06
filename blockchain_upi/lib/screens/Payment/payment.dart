import 'dart:convert';
import 'package:blockchain_upi/constants.dart';
import 'package:blockchain_upi/http/http.dart';
import 'package:blockchain_upi/screens/Login/mfa.dart';
import 'package:blockchain_upi/screens/Payment/cofirm_pin.dart';
import 'package:blockchain_upi/widgets/textbox.dart';
import 'package:blockchain_upi/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final String receiverAddress;
  const PaymentPage({super.key, required this.receiverAddress});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _ethController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  bool loading = false;

  String moneyInEth = "";

  double rate = 1.0;

  void changeRate() async {
    // Start loading indicator (optional)

    try {
      final response = await http.get(
        Uri.parse(
            "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=ETH&convert=INR"),
        headers: {
          'X-CMC_PRO_API_KEY':
              '', // Replace with your actual API key
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Check if the response contains the expected data
        if (data != null &&
            data['data'] != null &&
            data['data']['ETH'] != null &&
            data['data']['ETH']['quote'] != null &&
            data['data']['ETH']['quote']['INR'] != null) {
          double ethInInr =
              data['data']['ETH']['quote']['INR']['price'].toDouble();
          rate = ethInInr;

          // Calculate money in Ethereum
          moneyInEth = "${double.parse(_ethController.text) / ethInInr}";

          // Save the rate for future use
          setState(() {});
        } else {
          throw Exception('Data format error');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');

      // Use previously stored rate if available
      moneyInEth = rate == 1.0
          ? "Unable to fetch rate"
          : "${double.parse(_ethController.text) / rate}";

      setState(() {});
    }

    // Stop loading indicator (optional)
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 28,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          "Transaction",
          style: TextStyle(
            color: purple1,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: HttpApiCalls().getUserDetails(
            widget.receiverAddress, widget.receiverAddress == "user1@hdfcbank"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            print("fsfsfsfsfsfsfsfsf");
            print(data);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Transfer to",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bg1,
                            image: DecorationImage(
                              image: NetworkImage(data!['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['username'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.receiverAddress,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await Clipboard.setData(
                                        ClipboardData(
                                            text: widget.receiverAddress),
                                      );
                                      showToast(
                                          context,
                                          "Account Address Copied Successfully",
                                          3);
                                    },
                                    child: Icon(
                                      Icons.copy_rounded,
                                      color: black2,
                                      size: 23,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextBox(
                      controller: _ethController,
                      hinttext: "Enter Amount in INR",
                      label: "",
                      isNumber: true,
                      obscureText: false,
                      onChange: (p0) {
                        if (double.parse(p0) <= 100000.toDouble()) {
                          changeRate();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Max limit is 1,00,000 Rs.'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextBox(
                      controller: _reasonController,
                      hinttext: "Reason For Transaction",
                      label: "",
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (moneyInEth != "")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Equivalent ETH : $moneyInEth",
                            style: TextStyle(
                              color: purple1,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Gas fees : 0.13 Rs.",
                            style: TextStyle(
                              color: purple1,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Service Fees : ${double.parse(_ethController.text) * 0.04 / 100} Rs.",
                            style: TextStyle(
                              color: purple1,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: purple1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Total INR Payable: ${double.parse(_ethController.text) * 0.04 / 100 + 0.13.toDouble() + double.parse(_ethController.text)} Rs.",
                            style: TextStyle(
                              color: purple1,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              bool auth = await Authentication.authetication();
                              print("Authentication: $auth");

                              if (auth) {
                                setState(() {
                                  loading = true;
                                });
                                if (double.parse(_ethController.text) <
                                    100000.toDouble()) {
                                  if (_reasonController.text.isEmpty) {
                                    _reasonController.text = "other";
                                  }

                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => confirmScreen(),
                                    ),
                                  )
                                      .then((value) async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    // final ethAmountInWei = (ethAmount * BigInt.from(10).pow(18)).toString();
                                    final ethMoney =
                                        ((double.parse(_ethController.text) *
                                                        0.04 /
                                                        100 +
                                                    0.13.toDouble() +
                                                    double.parse(
                                                        _ethController.text)) /
                                                rate)
                                            .toString();

                                    final res =
                                        await HttpApiCalls().transaction({
                                      "acc1": prefs.getString("address") ?? "",
                                      "p1":
                                          prefs.getString("private_key") ?? "",
                                      'acc2':
                                          "0xd883B6eEc11eAa2308d34AE0da529ACeAD5Ff960",
                                      //'acc2': widget.receiverAddress,
                                      "tx_name": _reasonController.text,
                                      "eth": ethMoney,

                                      "date": DateTime.now().toString(),
                                      "upi_address": widget.receiverAddress,
                                      "inr" : _ethController.text
                                    });
                                    showToast(context, res['message'], 4);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Max limit is 1,00,000 Rs.'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple1,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Transfer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            for (var i = 0; i < 10; i++) {
              print(snapshot.error.toString());
            }
            print("WTFFFFFFF");
            return const Center(
              child: Text('No Internet Connection'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
