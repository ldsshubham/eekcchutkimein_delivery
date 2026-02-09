class BankDetailsResponse {
  final bool status;
  final String message;
  final BankDetailsData? data;

  BankDetailsResponse({required this.status, required this.message, this.data});

  factory BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    var dataElement = json['data'];
    BankDetailsData? parsedData;

    if (dataElement is List && dataElement.isNotEmpty) {
      parsedData = BankDetailsData.fromJson(dataElement.first);
    } else if (dataElement is Map<String, dynamic>) {
      parsedData = BankDetailsData.fromJson(dataElement);
    }

    return BankDetailsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }
}

class BankDetailsData {
  final int id;
  final String qrUrl;
  final String accountNo;
  final String ifsc;
  final String beneficiary;
  final String upiId;
  final String updatedAt;
  final String createdAt;

  BankDetailsData({
    required this.id,
    required this.qrUrl,
    required this.accountNo,
    required this.ifsc,
    required this.beneficiary,
    required this.upiId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory BankDetailsData.fromJson(Map<String, dynamic> json) {
    return BankDetailsData(
      id: json['id'] ?? 0,
      qrUrl: json['qr_url'] ?? '',
      accountNo: json['account_no'] ?? '',
      ifsc: json['ifsc'] ?? '',
      beneficiary: json['beneficiary'] ?? '',
      upiId: json['upi_id'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
