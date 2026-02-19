import 'package:eekcchutkimein_delivery/features/profile/controller/profile_controller.dart';
import 'package:eekcchutkimein_delivery/helper/textinput.dart';
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
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;

  // Editable controllers
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Address controllers
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  // Vehicle controllers
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
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
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _phoneController = TextEditingController(text: widget.profile.phone);

    _fatherNameController.text = widget.profile.fatherName;
    _dobController.text = widget.profile.dob;
    _emailController.text = widget.profile.email;

    _addressLine1Controller.text = widget.profile.addressLine1;
    _addressLine2Controller.text = widget.profile.addressLine2;
    _cityController.text = widget.profile.city;
    _stateController.text = widget.profile.state;
    _pinCodeController.text = widget.profile.pinCode;

    _vehicleNameController.text = widget.profile.vehicleName;
    _vehicleNumberController.text = widget.profile.vehicleNumber;
    _licenseNumberController.text = widget.profile.licenseNumber;
    if (_vehicleTypes.contains(widget.profile.vehicleType)) {
      _selectedVehicleType = widget.profile.vehicleType;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _vehicleNameController.dispose();
    _vehicleNumberController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_dobController.text) ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
                      readOnly: true,
                      onTap: _selectDate,
                      hintText: "YYYY-MM-DD",
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Email Address",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Address Details"),
                    MinimalInput(
                      label: "Address",
                      controller: _addressLine1Controller,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(label: "City", controller: _cityController),
                    const SizedBox(height: 16),
                    MinimalInput(label: "State", controller: _stateController),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Pin Code",
                      controller: _pinCodeController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Vehicle Details"),
                    const Text(
                      "Vehicle Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
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
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _vehicleTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedVehicleType = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Vehicle Name",
                      controller: _vehicleNameController,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "Vehicle Number",
                      controller: _vehicleNumberController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 16),
                    MinimalInput(
                      label: "License Number",
                      controller: _licenseNumberController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 16,
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
                      addressLine1: _addressLine1Controller.text.trim(),
                      addressLine2: _addressLine2Controller.text.trim(),
                      city: _cityController.text.trim(),
                      state: _stateController.text.trim(),
                      pinCode: _pinCodeController.text.trim(),
                      vehicleType: _selectedVehicleType,
                      vehicleName: _vehicleNameController.text.trim(),
                      vehicleNumber: _vehicleNumberController.text.trim(),
                      licenseNumber: _licenseNumberController.text.trim(),
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
