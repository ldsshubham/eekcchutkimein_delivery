import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/model/order_model.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/controller/order_controller.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/util/slidetostart_btn.dart';
import 'package:eekcchutkimein_delivery/features/ordersummry/util/uploadimage.dart';
import 'package:eekcchutkimein_delivery/features/ordersummry/view/ordersummery_screen.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/order_detail_model.dart';
import 'package:eekcchutkimein_delivery/helper/toastification_helper.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/view/towardscustomer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MultipleVendorPickup extends StatelessWidget {
  final OrderModel order;

  const MultipleVendorPickup({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final vendorCount = 4; // Replace later if backend gives count
    final isMultiVendor = vendorCount > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Order ID: ${order.orderId}",
          style: const TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔶 STATUS BANNER
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          "Pickup from Multiple Vendors",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🏬 Vendor Section
                  _sectionTitle("Vendor Details"),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Multiple Vendors",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.vendorAddress,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Total Vendor Amount: ₹${order.orderAmount}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 👤 Customer Section
                  _sectionTitle("Customer Details"),
                  const SizedBox(height: 8),

                  _infoTile(
                    title: order.customerName,
                    subtitle: order.customerAddress,
                  ),

                  const SizedBox(height: 20),

                  /// 🛒 Items
                  _sectionTitle("Items (${order.productList.length})"),
                  const SizedBox(height: 8),

                  ...order.productList.map(
                    (item) => _itemRow(
                      item.productName,
                      "x${item.productQuantity}",
                      "₹${item.total}",
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 💳 Payment Info
                  _sectionTitle("Payment Details"),
                  const SizedBox(height: 8),

                  _summaryRow("Payment Mode", order.paymentGateway),
                  _summaryRow("Payment Status", order.paymentStatus),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SlideToStartButton(
              textTitle: "Slide to confirm pickup",
              onSlideComplete: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OrderSummery(order: order)),
                );
              },
            ),
          ),
        ],
      ),
    );
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

  Widget _itemRow(String name, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(qty, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(price, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
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
}
