from flask import Flask, request, jsonify
from flask_cors import CORS
from supabase import create_client, Client

# Initialize Flask App
app = Flask(__name__)
CORS(app)

# Supabase Configuration
SUPABASE_URL = ""
SUPABASE_KEY = ""
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# API 1: Fetch UPI ID and Amount from Flutter Frontend
@app.route('/fetch-details', methods=['POST'])
def fetch_details():
    data = request.json
    upi_id = data.get('upi_id')
    amount = data.get('amount')
    
    if not upi_id or not amount:
        return jsonify({"error": "Missing UPI ID or amount"}), 400
    
    return jsonify({"message": "Details received successfully", "upi_id": upi_id, "amount": amount}), 200

# API 2: Map Payee and Payer Details
@app.route('/map-details', methods=['POST'])
def map_details():
    data = request.json
    payee_upi = data.get('payee_upi')
    amount = data.get('amount')

    if not payee_upi or not amount:
        return jsonify({"error": "Missing payee UPI ID or amount"}), 400

    # Query Payee Details from Unified Table
    payee_details = supabase.table('BankDetails').select("*").eq("upi_id", payee_upi).execute()

    if not payee_details.data:
        return jsonify({"error": "Payee UPI ID not found"}), 404

    payee = payee_details.data[0]

    # Retrieve All Bank Details
    all_bank_details = supabase.table('BankDetails').select("*").execute()

    if not all_bank_details.data:
        return jsonify({"error": "Bank details table is empty"}), 404

    # Check Payee's Bank
    payee_bank = payee['bank_name']
    if payee_bank == 'HDFC':
        # Filter Payer from SBI Bank
        sbi_bank_payers = [entry for entry in all_bank_details.data if entry['bank_name'] == 'SBI']
        if not sbi_bank_payers:
            return jsonify({"error": "No payers found from SBI bank"}), 404

        # Select the first SBI payer (or implement your selection logic)
        payer = sbi_bank_payers[0]
    else:
        # Default to a payer from the same index (modify this logic as needed)
        payee_index = all_bank_details.data.index(payee)
        payer_index = payee_index
        if len(all_bank_details.data) <= payer_index:
            return jsonify({"error": "Payer details not found"}), 404

        payer = all_bank_details.data[payer_index]

    if payer['upi_id'] == payee['upi_id']:
        return jsonify({"error": "Payer and Payee cannot be the same"}), 400

    # Construct Response
    response = {
        "payee": {
            "upi_id": payee['upi_id'],
            "amount": amount,
            "branch_name": payee['branch_name'],
            "bank_name": payee['bank_name'],
        },
        "payer": {
            "upi_id": "Intermediary",
            "amount": payer['amount'],
            "branch_name": payer['branch_name'],
            "bank_name": payer['bank_name'],
        },
    }

    return jsonify(response), 200


@app.route('/transfer-funds', methods=['POST'])
def transfer_funds():
    data = request.form
    payee_upi = data.get('payee_id')
    amount = data.get('amount')

    print(payee_upi)

    if not payee_upi or not amount:
        return jsonify({"error": "Missing payee UPI ID or amount"}), 400

    # Query Payee Details from Unified Table
    payee_details = supabase.table('BankDetails').select("*").eq("upi_id", payee_upi).execute()

    if not payee_details.data:
        return jsonify({"error": "Payee UPI ID not found"}), 404

    payee = payee_details.data[0]
    payee_new_balance = payee['amount'] + float(amount)
    print(payee['amount'], "    " , amount)

    # Update Payee's Balance in the Database
    supabase.table('BankDetails').update({"amount": payee_new_balance}).eq("upi_id", payee['upi_id']).execute()

    # Construct Response
    response = {
        "payee": {
            "upi_id": payee['upi_id'],
            "new_balance": payee_new_balance,
            "branch_name": payee['branch_name'],
            "bank_name": payee['bank_name'],
        }
    }

    return jsonify(response), 200

# Run Flask App
if __name__ == '__main__':
    app.run(debug=True, host="192.168.0.111", port="4000")
