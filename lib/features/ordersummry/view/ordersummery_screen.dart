import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/model/order_model.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/controller/order_controller.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/util/slidetostart_btn.dart';
import 'package:eekcchutkimein_delivery/features/ordersummry/util/uploadimage.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/order_detail_model.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/view/towardscustomer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

class OrderSummery extends StatelessWidget {
  final OrderModel? order;
  OrderSummery({super.key, this.order});

  final TowardsCustomerController controller =
      Get.find<TowardsCustomerController>();

  @override
  Widget build(BuildContext context) {
    final currentOrder = order ?? Get.arguments as OrderModel;

    // Fetch order details when screen loads
    if (controller.orderDetails.value == null) {
      controller.fetchOrderDetails(currentOrder.orderId);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final response = controller.orderDetails.value;
        if (response == null || response.data.orderDetails.isEmpty) {
          return const Center(child: Text("No order details found"));
        }

        final orderDetail = response.data.orderDetails.first;
        print("ORDER AT TOWARDS${orderDetail}");

        return Column(
          children: [
            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// STATUS BANNER
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.pedal_bike, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            "Heading to pickup location",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Vendor Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    _infoTile(
                      title: currentOrder.vendorName,
                      subtitle: currentOrder.vendorAddress,
                      latitude: orderDetail.vendorLatitude,
                      longitude: orderDetail.vendorLongitude,
                      trailing: Icons.navigation,
                      trailingColor: Colors.green,
                    ),

                    const SizedBox(height: 20),

                    /// CUSTOMER DETAILS
                    const Text(
                      "Customer Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    _infoTile(
                      title: currentOrder.customerName,
                      subtitle: currentOrder.customerAddress,
                    ),

                    const SizedBox(height: 20),

                    /// ITEMS
                    const Text(
                      "Items",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...currentOrder.productList
                        .map(
                          (item) => _itemRow(
                            item.productName,
                            "x${item.productQuantity}",
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SlideToStartButton(
                textTitle: "Slide to confirm order picked up!",
                onSlideComplete: () async {
                  _showUploadSheet(context, currentOrder);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _infoTile({
    required String title,
    required String subtitle,
    double? latitude,
    double? longitude,
    IconData? trailing,
    Color? trailingColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          if (trailing != null)
            InkWell(
              onTap: () {
                if (latitude != null && longitude != null) {
                  try {
                    MapsLauncher.launchCoordinates(latitude, longitude);
                  } catch (e) {
                    print("Error launching maps: $e");
                  }
                } else {
                  print("Latitude or longitude is null");
                }
              },
              child: Icon(trailing, color: trailingColor),
            ),
        ],
      ),
    );
  }

  /// ITEM ROW
  Widget _itemRow(String name, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(qty, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _showUploadSheet(
    BuildContext context,
    OrderModel currentOrder,
  ) async {
    final bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const UploadPackageSheet(),
    );

    // 👇 THIS RUNS AFTER SHEET IS CLOSED

    if (result == true) {
      final OrderController controller = Get.find<OrderController>();

      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await controller.startDelivery(currentOrder.orderId);

      // Close loading
      Get.back();

      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(message: "Delivery Started Successfully!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TowardsCustomerScreen(orderId: currentOrder.orderId),
          ),
        );
      } else {
        ToastHelper.showErrorToast(
          "Failed to start delivery",
          subMessage: response.statusText,
        );
      }
    } else {
      _showToast(context, 'Please upload package photo');
    }
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}
