import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro5/pages/onboarding/login_page.dart';
import 'package:pro5/pages/onboarding/user_profile_screen.dart';
import 'package:flutter/services.dart';
import 'package:pro5/services/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeToggle;

  const CustomDrawer({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return FutureBuilder<Map<String, dynamic>?>(
      future: authController.getUserDataFromFirestore(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final userName = data?['name'] ?? 'تطبيق التعلم للأطفال';
        final userGender =
            data?['gender'] ?? 'male'; // male أو female حسب ما خزنتيه

        // تختاري الصورة حسب الجنس
        final profileImage =
            userGender == 'female'
                ? 'assets/images/backgrounds/onbording-gril.png'
                : 'assets/images/backgrounds/onbording-boy.png';
        return Drawer(
          child: Container(
            color: isDarkMode ? Colors.black : Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.blue[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // يسكّر الـ Drawer
                              Get.to(() => UserProfileScreen());
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  profileImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          IconButton(
                            icon:
                                isDarkMode
                                    ? Icon(Icons.wb_sunny, color: Colors.white)
                                    : Icon(
                                      Icons.nights_stay,
                                      color: Colors.black,
                                    ),
                            onPressed: () => onDarkModeToggle(!isDarkMode),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                // باقي عناصر القائمة
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'الملف الشخصي',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => UserProfileScreen());
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'الإصدار 1.0.0',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text(
                              'حول التطبيق',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            content: Text(
                              'تطبيق تعليمي للأطفال\nالإصدار: 1.0.0',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            backgroundColor:
                                isDarkMode ? Colors.grey[900] : Colors.white,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'حسناً',
                                  style: TextStyle(
                                    color:
                                        isDarkMode
                                            ? Colors.blue[200]
                                            : Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'تسجيل خروج',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    AuthController().signOut();
                    Get.offAll(() => const LoginScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close, color: Colors.red),
                  title: Text(
                    'خروج من التطبيق',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text(
                              'تأكيد الخروج',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            content: Text(
                              'هل أنت متأكد أنك تريد الخروج من التطبيق؟',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            backgroundColor:
                                isDarkMode ? Colors.grey[900] : Colors.white,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    color:
                                        isDarkMode
                                            ? Colors.blue[200]
                                            : Colors.blue,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => SystemNavigator.pop(),
                                child: Text(
                                  'خروج',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
