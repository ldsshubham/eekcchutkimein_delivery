import 'dart:io';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPackageSheet extends StatefulWidget {
  const UploadPackageSheet();

  @override
  State<UploadPackageSheet> createState() => _UploadPackageSheetState();
}

class _UploadPackageSheetState extends State<UploadPackageSheet> {
  File? imageFile;
  final picker = ImagePicker();

  Future<void> _openCamera() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// drag handle
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Text(
              "Upload Package Photo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            const Text(
              "Please upload a clear image of the order/package",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// IMAGE PREVIEW
            GestureDetector(
              onTap: _openCamera,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 26),
                          // SizedBox(height: 8),
                          // Text("Tap to open camera"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // inside UploadPackageSheet
                onPressed: imageFile == null
                    ? null
                    : () {
                        Navigator.pop(context, true); // <-- send result back
                      },

                child: const Text(
                  "Confirm & Continue",
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
