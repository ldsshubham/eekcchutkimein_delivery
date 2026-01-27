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
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  // Editable controllers
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

  String? _selectedVehicleType;
  final List<String> _vehicleTypes = [
    'Bike',
    'Cycle',
    'Scooter',
    'Electric Scooter',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone);

    // Pre-fill existing data from profile if available
    _vehicleNameController.text =
        ""; // Should come from profile if added to model
    _vehicleNumberController.text = widget.profile.vehicleNumber;
    _selectedVehicleType = _vehicleTypes.contains(widget.profile.vehicleType)
        ? widget.profile.vehicleType
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    _vehicleNameController.dispose();
    _vehicleNumberController.dispose();
    _licenseController.dispose();
    _panController.dispose();
    _aadharController.dispose();
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
                      label: "Full Name",
                      controller: _nameController,
                      readOnly: true,
                      enabled: false,
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

                    const SizedBox(height: 32),

                    // _buildSectionHeader("Address Details"),
                    // MinimalInput(
                    //   label: "Address Line 1",
                    //   controller: _address1Controller,
                    // ),
                    // const SizedBox(height: 16),
                    // MinimalInput(
                    //   label: "Address Line 2",
                    //   controller: _address2Controller,
                    // ),
                    // const SizedBox(height: 16),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: MinimalInput(
                    //         label: "City",
                    //         controller: _cityController,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     Expanded(
                    //       child: MinimalInput(
                    //         label: "State",
                    //         controller: _stateController,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 16),
                    // MinimalInput(
                    //   label: "Pin Code",
                    //   controller: _pinController,
                    //   keyboardType: TextInputType.number,
                    // ),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Vehicle Details"),
                    _buildDropdownLabel("Vehicle Type"),
                    _buildVehicleDropdown(readOnly: true),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Vehicle Name",
                      controller: _vehicleNameController,
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Vehicle Number",
                      controller: _vehicleNumberController,
                      textCapitalization: TextCapitalization.characters,
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "License Number",
                      controller: _licenseController,
                      textCapitalization: TextCapitalization.characters,
                      readOnly: true,
                      enabled: false,
                    ),

                    const SizedBox(height: 32),
                    // _buildSectionHeader("Identity Documents"),
                    // MinimalInput(
                    //   label: "PAN Number",
                    //   controller: _panController,
                    //   textCapitalization: TextCapitalization.characters,
                    //   readOnly: true,
                    //   enabled: false,
                    // ),
                    // const SizedBox(height: 16),
                    // MinimalInput(
                    //   label: "Aadhar Number",
                    //   controller: _aadharController,
                    //   keyboardType: TextInputType.number,
                    //   readOnly: true,
                    //   enabled: false,
                    // ),
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

  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildVehicleDropdown({bool readOnly = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedVehicleType,
          hint: Text(
            "Select Vehicle Type",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: _vehicleTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: readOnly
              ? null
              : (String? newValue) {
                  setState(() {
                    _selectedVehicleType = newValue;
                  });
                },
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // UI Only for now
            Get.back();
            Get.snackbar(
              "Profile Updated",
              "Your details have been updated successfully.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
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
          child: const Text(
            "Save Changes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
