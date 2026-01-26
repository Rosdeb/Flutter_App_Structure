import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../utils/AppColor/app_colors.dart';

class CustomCountryCodePicker extends StatelessWidget {
  final String initialCountryCode;
  final TextEditingController countryCodeController;
  final Function(String dialCode, String countryName)? onCountryChanged;

  const CustomCountryCodePicker({
    super.key,
    this.initialCountryCode = 'BD',
    required this.countryCodeController,
    this.onCountryChanged,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IntlPhoneField(
      initialValue: "",
      showCursor: true,
      readOnly: false, // Prevents manual number input
      showDropdownIcon: true,
      dropdownTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: isDark
            ? AppColors.DarkThemeText
            : Theme.of(context).textTheme.titleSmall?.color ?? Colors.grey,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark
            ? AppColors.DarkThemeSurface
            : Colors.grey.withValues(alpha: 0.15),
        prefixIconConstraints: BoxConstraints(
          minWidth: 40.w, // or your desired width
          minHeight: 40.h, // or your desired height
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.Red.withValues(alpha: 0.30)
                : AppColors.Red,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            width: 1,
            color: isDark
                ? AppColors.DarkThemeDivider
                : AppColors.LightGray,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.Red.withValues(alpha: 0.30)
                : Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.Primary
                : AppColors.Primary,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none
        ),
        hintText: "Enter phone",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: isDark
              ? AppColors.DarkThemeSecondaryText
              : Theme.of(context).textTheme.titleSmall?.color,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 15),
      ),
      initialCountryCode: initialCountryCode,
      onCountryChanged: (country) {
        countryCodeController.text = country.dialCode;
        if (onCountryChanged != null) {
          onCountryChanged!(country.dialCode, country.name);
        }
      },
    );
  }
}
