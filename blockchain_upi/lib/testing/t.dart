import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class T extends StatefulWidget {
  const T({super.key});

  @override
  State<T> createState() => _TState();
}

class _TState extends State<T> {
  @override
  void initState() {
    insertDataIntoSupabase();
    super.initState();
  }

  Future<void> insertDataIntoSupabase() async {
    final supabase = Supabase.instance.client;

    // Data for HDFC Bank
    final hdfcBankData = [
      {
        'upi_id': 'user1@hdfcbank',
        'customer_id': 'CUST1001',
        'account_no': '1234567890',
        'ifsc_code': 'HDFC0001234',
        'branch_name': 'Andheri West',
        'amount': 56320.75
      },
      {
        'upi_id': 'user2@hdfcbank',
        'customer_id': 'CUST1002',
        'account_no': '9876543210',
        'ifsc_code': 'HDFC0005678',
        'branch_name': 'Bandra East',
        'amount': 12445.50
      },
      {
        'upi_id': 'user3@hdfcbank',
        'customer_id': 'CUST1003',
        'account_no': '1122446688',
        'ifsc_code': 'HDFC0004321',
        'branch_name': 'Thane',
        'amount': 34672.90
      },
      {
        'upi_id': 'user4@hdfcbank',
        'customer_id': 'CUST1004',
        'account_no': '2233445566',
        'ifsc_code': 'HDFC0008765',
        'branch_name': 'Mulund',
        'amount': 7890.00
      },
      {
        'upi_id': 'user5@hdfcbank',
        'customer_id': 'CUST1005',
        'account_no': '3344556677',
        'ifsc_code': 'HDFC0009999',
        'branch_name': 'Navi Mumbai',
        'amount': 15200.00
      },
      {
        'upi_id': 'user6@hdfcbank',
        'customer_id': 'CUST1006',
        'account_no': '4455667788',
        'ifsc_code': 'HDFC0001111',
        'branch_name': 'Vashi',
        'amount': 90050.25
      },
    ];

    // Data for SBI Bank
    final sbiBankData = [
      {
        'upi_id': 'user1@sbibank',
        'customer_id': 'CUST2001',
        'account_no': '5566778899',
        'ifsc_code': 'SBI0009876',
        'branch_name': 'Powai',
        'amount': 45630.80
      },
      {
        'upi_id': 'user2@sbibank',
        'customer_id': 'CUST2002',
        'account_no': '6677889900',
        'ifsc_code': 'SBI0005432',
        'branch_name': 'Borivali',
        'amount': 10540.00
      },
      {
        'upi_id': 'user3@sbibank',
        'customer_id': 'CUST2003',
        'account_no': '7788990011',
        'ifsc_code': 'SBI0007654',
        'branch_name': 'Kandivali',
        'amount': 23875.50
      },
      {
        'upi_id': 'user4@sbibank',
        'customer_id': 'CUST2004',
        'account_no': '8899001122',
        'ifsc_code': 'SBI0008765',
        'branch_name': 'Mira Road',
        'amount': 5430.25
      },
      {
        'upi_id': 'user5@sbibank',
        'customer_id': 'CUST2005',
        'account_no': '9900112233',
        'ifsc_code': 'SBI0006543',
        'branch_name': 'Dadar',
        'amount': 30120.75
      },
      {
        'upi_id': 'user6@sbibank',
        'customer_id': 'CUST2006',
        'account_no': '1234567891',
        'ifsc_code': 'SBI0004321',
        'branch_name': 'Churchgate',
        'amount': 76990.00
      },
    ];

    // Inserting data into hdfc_bank
    final responseHdfc = await supabase.from('hdfc_bank').upsert(hdfcBankData);

    if (responseHdfc.error != null) {
      print(
          "Error inserting data into hdfc_bank: ${responseHdfc.error?.message}");
    } else {
      print("Data inserted into hdfc_bank successfully!");
    }

    // Inserting data into sbi_bank
    final responseSbi = await supabase.from('sbi_bank').upsert(sbiBankData);

    if (responseSbi.error != null) {
      print(
          "Error inserting data into sbi_bank: ${responseSbi.error?.message}");
    } else {
      print("Data inserted into sbi_bank successfully!");
    }
  }

  void getData() async {
    final url = Uri.parse("");
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    final t = html.querySelector(
        "#crypto-updatable_y9lZZ_zbH_DZ1e8P4_yeiAY_2 > div.card-section.PZPZlf > div:nth-child(2) > span.pclqee");

    for (var i = 0; i < 10; i++) {
      print("t : $t");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
