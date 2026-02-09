import 'dart:convert';
import 'package:eekcchutkimein_delivery/features/profile/api/bankdetails_api.dart';
import 'package:eekcchutkimein_delivery/features/profile/model/bank_details_model.dart';
import 'package:get/get.dart';

class BankDetailsController extends GetxController {
  final BankDetailsApi _bankDetailsApi = Get.put(BankDetailsApi());
  var isLoading = false.obs;
  Rxn<BankDetailsData> bankDetails = Rxn<BankDetailsData>();

  Future<void> fetchBankDetails() async {
    isLoading.value = true;
    try {
      final response = await _bankDetailsApi.getBankDetails();
      print("FETCH STATUS: ${response.statusCode}");
      print("FETCH BODY: ${response.body}");

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          print("BODY IS STRING, DECODING...");
          try {
            body = jsonDecode(body);
          } catch (e) {
            print("JSON DECODE ERROR: $e");
          }
        } else {
          print("BODY IS ALREADY MAP/OBJECT: ${body.runtimeType}");
        }

        try {
          final bankResponse = BankDetailsResponse.fromJson(body);
          print(
            "PARSED RESPONSE - Status: ${bankResponse.status}, Data: ${bankResponse.data}",
          );

          if (bankResponse.status && bankResponse.data != null) {
            bankDetails.value = bankResponse.data;
            print(
              "BANK DETAILS UPDATED in Controller: ${bankDetails.value?.qrUrl}",
            );
          } else {
            print("BANK DETAILS NOT UPDATED: Status false or Data null");
          }
        } catch (e) {
          print("MODEL PARSING ERROR: $e");
        }
      } else {
        print("API ERROR: ${response.statusText}");
      }
    } catch (e) {
      print("FETCH BANK DETAILS EXCEPTION: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
