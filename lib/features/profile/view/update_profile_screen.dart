import 'package:eekcchutkimein_delivery/features/profile/controller/profile_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/textinput.dart';
import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  final DeliveryPartnerProfile profile;
  const UpdateProfileScreen({super.key, required this.profile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // Read-only controllers
  // Read-only controllers
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;

  // Editable controllers
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _phoneController = TextEditingController(text: widget.profile.phone);

    _fatherNameController.text = widget.profile.fatherName;
    _dobController.text = widget.profile.dob;
    _emailController.text = widget.profile.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSectionHeader("Personal Details"),
                    MinimalInput(
                      label: "First Name",
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Last Name",
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Phone Number",
                      controller: _phoneController,
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Father's Name",
                      controller: _fatherNameController,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Date of Birth",
                      controller: _dobController,
                      hintText: "DD/MM/YYYY",
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Email Address",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    final ProfileController profileController = Get.find<ProfileController>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => ElevatedButton(
            onPressed: profileController.isLoading.value
                ? null
                : () async {
                    await profileController.updateProfile(
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      fatherName: _fatherNameController.text.trim(),
                      dob: _dobController.text.trim(),
                      email: _emailController.text.trim(),
                    );
                    Get.back();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: profileController.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
