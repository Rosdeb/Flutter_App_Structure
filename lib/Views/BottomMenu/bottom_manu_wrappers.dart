// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pagedrop/Views/Screen/Discover/dicovers.dart';
// import 'package:pagedrop/Views/Screen/Explore/explore.dart';
// import 'package:pagedrop/Views/Screen/Newspappers/newspapers.dart';
// import 'package:pagedrop/Views/Screen/Profile/profile.dart';
// import 'package:pagedrop/controllers/Explore/explorecontroller.dart';
//
// import '../../controllers/BottomMenu/bottom_menu_controllers.dart';
// import '../../controllers/EditControllers/edit_profile.dart';
// import '../../utils/app_colors.dart';
// import 'bottom_navigations.dart';
//
// class BottomMenuWrappers extends StatefulWidget {
//   BottomMenuWrappers({super.key});
//
//   @override
//   State<BottomMenuWrappers> createState() => _BottomMenuWrappersState();
// }
//
// class _BottomMenuWrappersState extends State<BottomMenuWrappers> {
//   final BottomMenuControllers controller = Get.put(BottomMenuControllers());
//   //final Explorecontroller controller1 = Get.find<Explorecontroller>();
//   // Cache pages to avoid rebuilding them unnecessarily
//   final List<Widget> _pages = [
//     Explore(),
//     Discovers(),
//     Newspapers(),
//     Profile(),
//   ];
//
//   // Use Find instead of Put
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Obx(() => Scaffold(
//       backgroundColor: isDark ? AppColors.DarkThemeBackground : Colors.white,
//       body: SafeArea(
//         top: false,
//         child: IndexedStack(
//           index: controller.selectedIndex.value,
//           children: _pages,
//         ),
//       ),
//       bottomNavigationBar: IOSStyledBottomNav(
//           onTap: controller.selectTab,
//           currentIndex:  controller.selectedIndex.value,
//         ),
//     ));
//   }
// }