import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:flutter/material.dart';

class MinimalInput extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon;

  const MinimalInput({
    super.key,
    required this.label,
    this.obscure = false,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorText,
          ),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black87, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
