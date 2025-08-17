import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro5/pages/onboarding/login_page.dart';
import 'package:pro5/pages/onboarding/main_child_page.dart';
import 'package:pro5/pages/stag_three_four.dart';
import 'package:pro5/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataKideScreen extends StatefulWidget {
  const DataKideScreen({super.key});

  @override
  State<DataKideScreen> createState() => _DataKideScreenState();
}

class _DataKideScreenState extends State<DataKideScreen>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  String? gender; // 'male' أو 'female'
  String? selectedAgeGroup;
  DateTime? selectedBirthDate;

  late AnimationController girlPulseController;
  late AnimationController boyPulseController;
  late AnimationController buttonShadowController;
  late Animation<double> girlPulseAnimation;
  late Animation<double> boyPulseAnimation;
  late Animation<Color?> buttonShadowColor;

  String? nameError;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // تهيئة المتحكمات للرسوم المتحركة
    girlPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    boyPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    girlPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(girlPulseController);
    boyPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(boyPulseController);

    buttonShadowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    buttonShadowColor = ColorTween(
      begin: Colors.blue.withOpacity(0.3),
      end: Colors.blue.withOpacity(0.7),
    ).animate(buttonShadowController);

    // التحقق من صحة الاسم
    nameController.addListener(() {
      setState(() {
        final pattern = RegExp(r"^[\u0621-\u064Aa-zA-Z\s]+$");
        if (nameController.text.isEmpty) {
          nameError = null;
        } else if (!pattern.hasMatch(nameController.text)) {
          nameError = 'الاسم يجب أن يحتوي حروف فقط';
        } else {
          nameError = null;
        }
      });
    });

    loadUserData();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 12)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
        birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _updateAgeGroup(picked);
      });
    }
  }

  void _updateAgeGroup(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    if (age >= 3 && age <= 4) {
      selectedAgeGroup = '3-4';
    } else if (age >= 5 && age <= 6) {
      selectedAgeGroup = '5-6';
    } else {
      selectedAgeGroup = null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    girlPulseController.dispose();
    boyPulseController.dispose();
    buttonShadowController.dispose();
    super.dispose();
  }

  Future<void> saveUserData() async {
    final authController = Get.find<AuthController>();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar('تحذير', 'لا يوجد مستخدم مسجل');
      return;
    }

    // 1. حفظ البيانات محلياً
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('name', nameController.text);
    if (selectedBirthDate != null) {
      await prefs.setString('birthDate', selectedBirthDate!.toIso8601String());
    }
    if (gender != null) {
      await prefs.setString('gender', gender!);
    }
    if (selectedAgeGroup != null) {
      await prefs.setString('ageGroup', selectedAgeGroup!);
    }

    // 2. حفظ البيانات في Firestore
    await authController.storeUserInfo(
      uid: user.uid,
      name: nameController.text,
      birthDate: selectedBirthDate?.toIso8601String(),
      ageGroup: selectedAgeGroup,
      gender: gender,
    );
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (loggedIn) {
      setState(() {
        nameController.text = prefs.getString('name') ?? '';
        final birthDateStr = prefs.getString('birthDate');
        if (birthDateStr != null) {
          selectedBirthDate = DateTime.parse(birthDateStr);
          birthDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(selectedBirthDate!);
          _updateAgeGroup(selectedBirthDate!);
        }
        gender = prefs.getString('gender');
        selectedAgeGroup = prefs.getString('ageGroup');
      });
    }
  }

  Color getBackgroundColor() {
    if (gender == 'male') {
      return Colors.blue[100]!;
    } else if (gender == 'female') {
      return Colors.pink[100]!;
    } else {
      return Colors.lightBlue[50]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => LoginScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: getBackgroundColor(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'مغامرتك تبدأ هنا',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (nameController.text.isNotEmpty && nameError == null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            nameController.text,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'الاسم',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          errorText: nameError,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'تاريخ الميلاد',
                          prefixIcon: const Icon(Icons.cake),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectBirthDate(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText:
                              selectedBirthDate == null
                                  ? 'اختر تاريخ الميلاد'
                                  : DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(selectedBirthDate!),
                        ),
                        onTap: () => _selectBirthDate(context),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedAgeGroup,
                        decoration: InputDecoration(
                          labelText: 'الفئة العمرية',
                          prefixIcon: const Icon(Icons.group),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: '3-4',
                            child: Text('3 - 4 سنوات'),
                          ),
                          DropdownMenuItem(
                            value: '5-6',
                            child: Text('5 - 6 سنوات'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAgeGroup = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الرجاء اختيار الفئة العمرية';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'اختر جنسك:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: girlPulseController,
                            builder: (context, child) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gender = 'female';
                                  });
                                },
                                child: Transform.scale(
                                  scale:
                                      gender == 'female'
                                          ? girlPulseAnimation.value
                                          : 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow:
                                          gender == 'female'
                                              ? [
                                                BoxShadow(
                                                  color: Colors.pinkAccent
                                                      .withOpacity(0.6),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ]
                                              : [],
                                    ),
                                    child: Image.asset(
                                      'assets/images/backgrounds/onbording-gril.png',
                                      height: 80,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          AnimatedBuilder(
                            animation: boyPulseController,
                            builder: (context, child) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gender = 'male';
                                  });
                                },
                                child: Transform.scale(
                                  scale:
                                      gender == 'male'
                                          ? boyPulseAnimation.value
                                          : 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow:
                                          gender == 'male'
                                              ? [
                                                BoxShadow(
                                                  color: Colors.blueAccent
                                                      .withOpacity(0.6),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ]
                                              : [],
                                    ),
                                    child: Image.asset(
                                      'assets/images/backgrounds/onbording-boy.png',
                                      height: 80,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      AnimatedBuilder(
                        animation: buttonShadowColor,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: buttonShadowColor.value!,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () async {
                                        if (nameController.text.isNotEmpty &&
                                            nameError == null &&
                                            selectedBirthDate != null &&
                                            selectedAgeGroup != null &&
                                            gender != null) {
                                          setState(() => isLoading = true);

                                          await saveUserData(); // حفظ البيانات أولاً

                                          setState(() => isLoading = false);

                                          // الانتقال إلى الشاشة التالية
                                          Get.offAll(
                                            () => const MainChildPage(),
                                          );
                                        } else {
                                          Get.snackbar(
                                            'خطأ',
                                            'الرجاء تعبئة جميع الحقول بشكل صحيح',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                              child:
                                  isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        'ابدأ المغامرة',
                                        style: TextStyle(fontSize: 20),
                                      ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
