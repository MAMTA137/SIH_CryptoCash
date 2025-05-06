// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class UPIQRPage extends StatefulWidget {
//   const UPIQRPage({super.key});
//
//   @override
//   State<UPIQRPage> createState() => _UPIQRPageState();
// }
//
// class _UPIQRPageState extends State<UPIQRPage> {
//   final String qrData = "user1@hdfcbank";
//   double? accountBalance;
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAccountBalance();
//
//     // Set up periodic fetching of account balance every 5 seconds
//     timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
//       fetchAccountBalance();
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> fetchAccountBalance() async {
//     try {
//       final response = await Supabase.instance.client
//           .from('BankDetails')
//           .select('amount')
//           .eq('upi_id', qrData)
//           .single();
//
//       if (response != null) {
//         setState(() {
//           accountBalance = response['amount'] as double?;
//         });
//       }
//     } catch (error) {
//       print("Error fetching account balance: $error");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Container(
//             margin: const EdgeInsets.only(left: 10),
//             child: const Icon(
//               Icons.arrow_back_ios_rounded,
//               size: 28,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: QrImageView(
//                 data: qrData,
//                 version: QrVersions.auto,
//                 size: 260.0,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             const Text(
//               "Google Play UPI QR Scanner",
//               style: TextStyle(
//                 color: Colors.deepPurple,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 28,
//               ),
//             ),
//             const SizedBox(
//               height: 25,
//             ),
//             if (accountBalance != null)
//               Text(
//                 "Account Balance: ₹${accountBalance!.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             else
//               const CircularProgressIndicator(),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class UPIQRPage extends StatefulWidget {
  const UPIQRPage({super.key});

  @override
  State<UPIQRPage> createState() => _UPIQRPageState();
}

class _UPIQRPageState extends State<UPIQRPage> {
  final String qrData = "user1@hdfcbank";
  double? accountBalance;
  double? previousBalance;
  Timer? timer;
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    fetchAccountBalance();

    // Set up periodic fetching of account balance every 5 seconds
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      fetchAccountBalance();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    tts.stop();
    super.dispose();
  }

  Future<void> fetchAccountBalance() async {
    try {
      final response = await Supabase.instance.client
          .from('BankDetails')
          .select('amount')
          .eq('upi_id', qrData)
          .single();

      final newBalance = response['amount'] as double?;

      if (newBalance != null && accountBalance != null) {
        // Detect transaction and announce
        // print("$newBalance ====== $accountBalance");
        double difference = newBalance - accountBalance!;
        if (difference > 0) {
          announceTransaction(
              "Received ₹${difference.toInt()} Rupees from CryptoCash");
        } else if (difference < 0) {
          announceTransaction("Paid ₹${difference.abs().toStringAsFixed(2)}");
        }
      }

      setState(() {
        previousBalance = accountBalance;
        accountBalance = newBalance;
      });
    } catch (error) {
      print("Error fetching account balance: $error");
    }
  }

  Future<void> announceTransaction(String message) async {
    await tts.speak(message);
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 260.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Google Play UPI QR Scanner",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w700,
                fontSize: 28,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            if (accountBalance != null)
              Text(
                "Account Balance: ₹${accountBalance!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const CircularProgressIndicator(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
