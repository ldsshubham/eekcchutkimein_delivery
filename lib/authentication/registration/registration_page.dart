import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/textinput.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateofbirthController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  String? _selectedVehicleType;
  final List<String> _vehicleTypes = [
    'Bike',
    'Cycle',
    'Scooter',
    'Electric Scooter',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _panController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dateofbirthController.dispose();
    _fatherNameController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.to(() => const Homepage());
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
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: _currentStep >= 1
                      ? Colors.black
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentStep = page;
                  });
                },
                children: [_buildPersonalStep(), _buildDocumentStep()],
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
                    _currentStep == 0 ? "Next: Documents" : "Submit & Register",
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
            "Step 1 of 2: Let's start with your basics.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          MinimalInput(
            label: 'Full Name',
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Father\'s Name',
            controller: _fatherNameController,
            textCapitalization: TextCapitalization.words,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'D.O.B',
            controller: _dateofbirthController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.calendar_today_outlined),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Email Address',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'PAN Number',
            controller: _panController,
            textCapitalization: TextCapitalization.characters,
            prefixIcon: const Icon(Icons.credit_card),
          ),
          const SizedBox(height: 20),
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
            label: 'Vehicle Number',
            controller: _vehicleNumberController,
            textCapitalization: TextCapitalization.characters,
            prefixIcon: const Icon(Icons.security_outlined),
          ),
          const SizedBox(height: 20),
          MinimalInput(
            label: 'Address',
            controller: _addressController,
            maxLines: 3,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDocumentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Document Upload",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Step 2 of 2: Upload documents for verification.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _buildUploadCard("Profile Photo", Icons.camera_alt_outlined),
          _buildUploadCard("Aadhar Card (Front)", Icons.badge_outlined),
          _buildUploadCard("Aadhar Card (Back)", Icons.badge_outlined),
          _buildUploadCard("PAN Card", Icons.credit_card_outlined),
          _buildUploadCard("Driving License", Icons.drive_eta_outlined),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUploadCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black54),
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
                  "Upload clear image",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const Icon(Icons.add_circle_outline, color: Colors.black),
        ],
      ),
    );
  }
}
