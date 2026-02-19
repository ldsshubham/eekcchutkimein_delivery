import 'dart:io';

import 'package:eekcchutkimein_delivery/authentication/controller/pickimage.dart';
import 'package:eekcchutkimein_delivery/authentication/controller/registration_controller.dart';
import 'package:eekcchutkimein_delivery/helper/textinput.dart';
import 'package:eekcchutkimein_delivery/helper/toastification_helper.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  final String? phoneNumber;
  const RegistrationPage({super.key, this.phoneNumber});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final PageController _pageController = PageController();
  final PickImageController _pickImageController = Get.put(
    PickImageController(),
  );
  final RegistrationController _controller = Get.put(RegistrationController());
  int _currentStep = 0;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _addressline1Controller = TextEditingController();
  final TextEditingController _addressline2Controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateofbirthController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();

  // Address controllers
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  // Vehicle controllers
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();

  // Identity controllers

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
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (widget.phoneNumber != null) {
      _phoneController.text = widget.phoneNumber!;
    } else {
      final savedPhone = await TokenService.getSavedPhoneNumber();
      if (savedPhone != null) {
        _phoneController.text = savedPhone;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _panController.dispose();
    _addressline1Controller.dispose();
    _addressline2Controller.dispose();
    _phoneController.dispose();
    _dateofbirthController.dispose();
    _fatherNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _vehicleNameController.dispose();
    _vehicleNumberController.dispose();
    _licenseNumberController.dispose();
    _aadharController.dispose();
    super.dispose();
  }

  bool _validateStep1() {
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_firstnameController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter your full name",
      );

      return false;
    }
    if (_lastnameController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter your full name",
      );
      return false;
    }
    if (_phoneController.text.trim().isEmpty ||
        !phoneRegex.hasMatch(_phoneController.text.trim())) {
      ToastHelper.showWarningToast(message: "Error: Please valid phone number");
      return false;
    }

    if (_emailController.text.trim().isEmpty ||
        !emailRegex.hasMatch(_emailController.text.trim().toLowerCase())) {
      ToastHelper.showWarningToast(message: "Error: Please enter valid email");
      return false;
    }
    if (_dateofbirthController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please select date of birth",
      );
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (_addressline1Controller.text.trim().isEmpty) {
      ToastHelper.showWarningToast(message: "Error: Please enter your address");
      return false;
    }
    if (_cityController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(message: "Error: Please enter your city");
      return false;
    }
    if (_stateController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(message: "Error: Please enter your state");
      return false;
    }
    if (_pinCodeController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter your pin code",
      );
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    if (_selectedVehicleType == null) {
      ToastHelper.showWarningToast(
        message: "Error: Please select a vehicle type",
      );
      return false;
    }
    if (_vehicleNameController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(message: "Error: Please enter vehicle name");
      return false;
    }
    if (_vehicleNumberController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter vehicle number",
      );
      return false;
    }
    if (_vehicleNumberController.text.trim().length < 8 ||
        _vehicleNumberController.text.trim().length > 12) {
      ToastHelper.showWarningToast(
        message: "Error: Vehicle number must be between 8 and 12 characters",
      );
      return false;
    }
    if (_licenseNumberController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter license number",
      );
      return false;
    }
    if (_licenseNumberController.text.trim().length < 14 ||
        _licenseNumberController.text.trim().length > 16) {
      ToastHelper.showWarningToast(
        message: "Error: License number must be between 14 and 16 characters",
      );
      return false;
    }
    return true;
  }

  bool _validateStep4() {
    if (_panController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter your PAN number",
      );
      return false;
    }
    if (_aadharController.text.trim().isEmpty) {
      ToastHelper.showWarningToast(
        message: "Error: Please enter your Aadhar number",
      );
      return false;
    }
    // if (_controller.selfieImageId.value == null) {
    //   ToastHelper.showWarningToast(message: "Error: Please upload a selfie");
    //   return false;
    // }
    // if (_controller.panImageId.value == null) {
    //   ToastHelper.showWarningToast(
    //     message: "Error: Please upload PAN card image",
    //   );
    //   return false;
    // }
    return true;
  }

  void _nextPage() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 1) {
      if (_validateStep2()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 2) {
      if (_validateStep3()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      if (_validateStep4()) {
        _submitData();
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateofbirthController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitData() {
    try {
      final data = {
        'firstName': _firstnameController.text.trim(),
        'lastName': _lastnameController.text.trim(),
        'fatherName': _fatherNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dateofbirthController.text.trim(),
        'email': _emailController.text.trim(),
        'Addressline_1': _addressline1Controller.text.trim(),
        'Addressline_2': _addressline2Controller.text.trim(),
        'user_image_id':
            _pickImageController.selfieImageId.value?.toInt() ?? 23,
        'pancard_number_id':
            _pickImageController.panImageId.value?.toInt() ?? 0,
        'pancard_number': _panController.text.trim(),
        'aadharcard_number': _aadharController.text.trim(),
        'vehicleType': _selectedVehicleType ?? "Not Selected",
        'vehicleNumber': _vehicleNumberController.text.trim(),
        'vehicleName': _vehicleNameController.text.trim(),
        'license_number': _licenseNumberController.text.trim(),
        'city': _cityController.text.trim(),
        'pinCode': int.tryParse(_pinCodeController.text.trim()) ?? 0,
        'state': _stateController.text.trim(),
      };

      debugPrint('Collected Registration Data: $data');
      print("RESISTRATION DATA : ${data.toString()}");
      _controller.registerEmployee(data);
    } catch (e) {
      debugPrint('Error during registration submission: $e');
      ToastHelper.showErrorToast("Something went wrong. Please try again.");
      // Get.snackbar(
      //   "Error",
      //   "Something went wrong. Please try again.",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red.withOpacity(0.8),
      //   colorText: Colors.white,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentStep = page;
                  });
                },
                children: [
                  _buildPersonalStep(),
                  _buildAddressStep(),
                  _buildVehicleStep(),
                  _buildIdentityAndUploadStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentStep == 3
                        ? "Submit"
                        : _currentStep == 0
                        ? "Next: Address"
                        : _currentStep == 1
                        ? "Next: Vehicle"
                        : "Next: Identity & Uploads",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Data",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Step 1 of 4: Let's start with your basics.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          MinimalInput(
            label: 'First Name',
            controller: _firstnameController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Last Name',
            controller: _lastnameController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Father\'s Name',
            controller: _fatherNameController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            readOnly: widget.phoneNumber != null,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'D.O.B',
            controller: _dateofbirthController,
            readOnly: true,
            onTap: _selectDate,
            hintText: "Select Date of Birth",
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Email Address',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Address Details",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Step 2 of 4: Where are you located?",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          MinimalInput(
            label: 'Address Line 1',
            controller: _addressline1Controller,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Address Line 2',
            controller: _addressline2Controller,
          ),
          const SizedBox(height: 20),
          // SelectState(_aadharNumberController),
          MinimalInput(label: 'City', controller: _cityController),
          const SizedBox(height: 20),
          MinimalInput(label: 'State', controller: _stateController),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Pin Code',
            controller: _pinCodeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVehicleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Details",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Step 3 of 4: Provide your vehicle details.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
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
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
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
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Vehicle Name',
            controller: _vehicleNameController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Vehicle Number',
            controller: _vehicleNumberController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 12,
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'License Number',
            controller: _licenseNumberController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 16,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIdentityAndUploadStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Identity & Uploads",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Step 4 of 4: Provide identity details and photos.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          MinimalInput(
            label: 'PAN Number',
            controller: _panController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 10,
            prefixIcon: const Icon(Icons.credit_card),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Aadhar Number',
            controller: _aadharController,
            maxLength: 12,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          const SizedBox(height: 30),
          Obx(
            () => _buildUploadCard(
              "Selfie",
              Icons.camera_alt_outlined,
              _pickImageController.selfieImage.value,
              _pickImageController.selfieImageId.value,
              _pickImageController.isSelfieUploading.value,
              () => _showImageSourceDialog('selfie'),
              () => _pickImageController.uploadCapturedImage('selfie'),
              () => _pickImageController.resetImage('selfie'),
            ),
          ),
          Obx(
            () => _buildUploadCard(
              "PAN Card Image",
              Icons.credit_card_outlined,
              _pickImageController.panImage.value,
              _pickImageController.panImageId.value,
              _pickImageController.isPanUploading.value,
              () => _showImageSourceDialog('pan'),
              () => _pickImageController.uploadCapturedImage('pan'),
              () => _pickImageController.resetImage('pan'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showImageSourceDialog(String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageController.pickImage(ImageSource.camera, type);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageController.pickImage(ImageSource.gallery, type);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(
    String title,
    IconData icon,
    XFile? image,
    int? id,
    bool isUploading,
    VoidCallback onPick,
    VoidCallback onUpload,
    VoidCallback onReset,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: id != null ? Colors.green.shade300 : Colors.grey.shade200,
          width: id != null ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: id != null ? null : (image != null ? null : onPick),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: id != null
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    image: image != null
                        ? DecorationImage(
                            image: FileImage(File(image.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: image == null
                      ? Icon(icon, color: Colors.black54)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      id != null
                          ? "Uploaded Successfully"
                          : image != null
                          ? "Ready to upload"
                          : "Tap icon to select",
                      style: TextStyle(
                        fontSize: 12,
                        color: id != null
                            ? Colors.green.shade700
                            : image != null
                            ? Colors.blue.shade700
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              if (id != null) ...[
                const Icon(Icons.check_circle, color: Colors.green),
                IconButton(
                  onPressed: onReset,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black54,
                    size: 20,
                  ),
                  tooltip: "Retake",
                ),
              ] else if (image != null && !isUploading)
                IconButton(
                  onPressed: onReset,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  tooltip: "Remove",
                ),
            ],
          ),
          if (image != null && id == null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isUploading ? null : onUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isUploading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Upload Now",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onPick,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Retake", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
