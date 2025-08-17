import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro5/services/auth_service.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // استدعاء البيانات عند فتح الشاشة
    authController.fetchUserData();

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                // هنا يمكنك إضافة التنقل لشاشة التعديل
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.black54),
                        SizedBox(width: 10),
                        Text('تعديل المعلومات'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              // صورة شخصية حسب الجنس
              Obx(
                () => CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    authController.gender.value == 'female'
                        ? 'assets/images/backgrounds/onbording-gril.png'
                        : 'assets/images/backgrounds/onbording-boy.png',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // الاسم
              Obx(
                () => Text(
                  authController.fullName.value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // المرحلة والعمر
              Obx(
                () => Text(
                  'الفئة العمرية: ${authController.ageGroup.value}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 30),

              // كارد أداء الطفل
              Card(
                color: Colors.green[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.arrow_forward, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            'أداء الطفل',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'عدد الألعاب المنجزة:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${authController.gamesCompleted.value}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'عدد النجوم:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${authController.starsEarned.value} ⭐',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'أكثر قسم محبب:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              authController.favoriteSection.value,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتحديد المرحلة حسب العمر
  String getStage(int age) {
    if (age >= 3 && age <= 4) return 'المرحلة 3-4 سنوات';
    if (age >= 5 && age <= 6) return 'المرحلة 5-6 سنوات';
    return 'غير محددة';
  }
}
