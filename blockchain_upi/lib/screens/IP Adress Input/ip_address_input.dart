import 'package:blockchain_upi/constants.dart';
import 'package:blockchain_upi/screens/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:blockchain_upi/widgets/textbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpAddressInputScreen extends StatefulWidget {
  const IpAddressInputScreen({super.key});

  @override
  State<IpAddressInputScreen> createState() => _IpAddressInputScreenState();
}

class _IpAddressInputScreenState extends State<IpAddressInputScreen> {
  TextEditingController ip_address_controller = TextEditingController();

  bool _isToggled = false;
  void _toggle() {
    setState(() {
      _isToggled = !_isToggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextBox(
              controller: ip_address_controller,
              hinttext: "Enter IP Address",
              label: "",
              obscureText: false,
              isPassword: false,
              isNumber: false,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  "Do You want to hide features",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Switch(
                  value: _isToggled,
                  onChanged: (value) {
                    _toggle();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setString(
                  "ip_address",
                  ip_address_controller.text.trim(),
                );

                await prefs.setBool('hide', _isToggled);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purple1,
                fixedSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Save Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
