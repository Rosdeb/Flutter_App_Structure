import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/AppColor/app_colors.dart';
import '../../utils/AppIcons/app_icons.dart';

class IOSStyledBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const IOSStyledBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  Color _getColor(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return index == currentIndex
        ? (isDark ? AppColors.DarkThemeText : AppColors.Black)
        : (isDark
        ? AppColors.DarkThemeSecondaryText
        : AppColors.DarkGray);
  }

  static const List<String> icons = [
    'assets/icons/Icone_dasboard.svg',
    'assets/icons/discover.svg',
    'assets/icons/nonun_newspapers.svg',
    'assets/icons/Icone.svg',
  ];

  static const List<String> iconsSelected = [
    'assets/icons/explore2.svg',
    'assets/icons/discover.svg',
    'assets/icons/nonun_newspapers.svg',
    'assets/icons/profile2.svg',
  ];

  static const List<String> labels = [
    'Explore',
    'Discover',
    'Newspapers',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet =
        MediaQuery.of(context).size.shortestSide >= 600;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.DarkThemeSurface
            : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.DarkThemeDivider
                : Colors.grey.shade300,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black)
                .withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding:
          EdgeInsets.symmetric(vertical: isTablet ? 12 : 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              labels.length,
                  (index) => Expanded(
                child: _buildNavItem(context, index, isTablet),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      int index,
      bool isTablet,
      ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 4 : 4.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              child: SvgPicture.asset(
                isSelected
                    ? iconsSelected[index]
                    : icons[index],
                height: isTablet ? 24 : 24.w,
                width: isTablet ? 24 : 24.w,
                colorFilter: ColorFilter.mode(
                  _getColor(context, index),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(
              height: isTablet ? 4 : 4.h,
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              style: TextStyle(
                fontSize: isSelected
                    ? (isTablet ? 11.5 : 11.5.sp)
                    : (isTablet ? 11 : 11.sp),
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: _getColor(context, index),
                letterSpacing: -0.2,
              ),
              child: Text(
                labels[index].tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
