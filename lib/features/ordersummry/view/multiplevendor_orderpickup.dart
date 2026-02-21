import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/controller/order_controller.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/util/slidetostart_btn.dart';
import 'package:eekcchutkimein_delivery/features/ordersummry/util/uploadimage.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/order_detail_model.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/view/towardscustomer_screen.dart';
import 'package:eekcchutkimein_delivery/helper/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MultipleVendorPickup extends StatefulWidget {
  final int orderId;

  const MultipleVendorPickup({super.key, required this.orderId});

  @override
  State<MultipleVendorPickup> createState() => _MultipleVendorPickupState();
}

class _MultipleVendorPickupState extends State<MultipleVendorPickup> {
  final TowardsCustomerController controller =
      Get.find<TowardsCustomerController>();
  final Set<int> pickedProductIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = controller.orderDetails.value;

      if (response == null || controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      final orderInfo = response.data.orderDetails.first;
      final products = response.data.detailsProductTable;

      // Check if all products from all vendors are picked
      final bool allProductsPicked =
          pickedProductIds.length == products.length && products.isNotEmpty;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Order ID: ${orderInfo.orderId}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: AppColors.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
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
                          "Verify pickups from vendors",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle("Customer Details"),
                  const SizedBox(height: 8),
                  _infoTile(
                    title: orderInfo.customerName,
                    subtitle: orderInfo.deliveryAddress,
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Vendors & Products"),
                  const SizedBox(height: 8),

                  ..._buildVendorSections(
                    products,
                    orderInfo.vendorLatitude,
                    orderInfo.vendorLongitude,
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Payment"),
                  const SizedBox(height: 8),
                  _summaryRow("Gateway", orderInfo.gateway),
                  _summaryRow("Status", orderInfo.paymentStatus ?? "Pending"),
                ],
              ),
            ),

            // Show Slide to confirm only if all are picked
            if (allProductsPicked)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SlideToStartButton(
                  textTitle: "Slide to confirm order picked up!",
                  onSlideComplete: () async {
                    _showUploadSheet(context, widget.orderId);
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildVendorSections(
    List<ProductTableDetail> products,
    double latitude,
    double longitude,
  ) {
    final Map<int, List<ProductTableDetail>> grouped = {};

    for (var product in products) {
      grouped.putIfAbsent(product.vendorId, () => []).add(product);
    }

    return grouped.entries.map((entry) {
      final vendorProducts = entry.value;
      final vendor = vendorProducts.first;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Vendor Info
            Row(
              children: [
                Text(
                  vendor.vendorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    vendor.vendorAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(latitude, longitude);
                  },
                  child: Icon(Icons.navigation_sharp, color: AppColors.green),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(),

            ...vendorProducts.map((item) {
              final isPicked = pickedProductIds.contains(item.productId);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isPicked,
                      activeColor: AppColors.green,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            pickedProductIds.add(item.productId);
                          } else {
                            pickedProductIds.remove(item.productId);
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        item.productName,
                        style: TextStyle(
                          decoration: isPicked
                              ? TextDecoration.lineThrough
                              : null,
                          color: isPicked ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "₹${item.finalAmount}",
                      style: TextStyle(
                        decoration: isPicked
                            ? TextDecoration.lineThrough
                            : null,
                        color: isPicked ? Colors.grey : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("x${item.quantity}"),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    }).toList();
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _infoTile({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _showUploadSheet(BuildContext context, int orderId) async {
    final bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const UploadPackageSheet(),
    );

    if (result == true) {
      final OrderController orderController = Get.find<OrderController>();

      // Show loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
        barrierDismissible: false,
      );

      final response = await orderController.startDelivery(orderId);

      // Close loading
      Get.back();

      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(message: "Delivery Started Successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TowardsCustomerScreen(orderId: orderId),
          ),
        );
      } else {
        ToastHelper.showErrorToast(
          "Failed to start delivery",
          subMessage: response.statusText,
        );
      }
    } else {
      _showToast(context, 'Please upload package photo to proceed');
    }
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}
