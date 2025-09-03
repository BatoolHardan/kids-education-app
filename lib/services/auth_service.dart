import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pro5/pages/onboarding/main_child_page.dart';
import 'package:pro5/pages/stag_five_six.dart';
import 'package:pro5/pages/stag_three_four.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

       Future<String> getScore(String gameName) async{
   DocumentSnapshot documentSnapshot= await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
   .collection('scores').doc(gameName).get();
         
         if(documentSnapshot.exists){
         return documentSnapshot.get('score').toString();
         }else {return '0';}
  } 

    
  // ✅ متغيرات المستخدم
  RxString fullName = 'مستخدم'.obs;
  RxString TotalSum = '0'.obs; // ✅ جديد
    RxString ageGroup = 'غير محدد'.obs;      
  RxString gender = 'غير محدد'.obs;
  RxString Taqdeer = 'غير محدد'.obs;
//  RxInt starsEarned = 0.obs;
  RxString favoriteSection = 'غير معروف'.obs;
  RxString scourColor = '0'.obs;
  RxString scourAnimal = '0'.obs;
  RxString scourLitter = '0'.obs;
  RxString scourShape = '0'.obs;
  RxString scourNum = '0'.obs;
  RxString scourSens = '0'.obs;
  RxString scourProf = '0'.obs;
  RxString scourSeason = '0'.obs;

      String getSum(){
      double sum=double.parse(scourAnimal.value)+double.parse(scourColor.value)+double.parse(scourLitter.value)
      +double.parse(scourSeason.value)+double.parse(scourSens.value)+double.parse(scourShape.value)+double.parse(scourNum.value)
      +double.parse(scourProf.value);
   
     return sum.toStringAsFixed(2);

    }
  /// ✅ إنشاء الحساب باستخدام الإيميل والباسوورد
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('خطأ', e.message ?? 'فشل في إنشاء الحساب');
      return null;
    }
  }

String getTaqdeer(){
    if( double.parse(TotalSum.value)>60) {
      return 'ممتاز😍';
    }else if( double.parse(TotalSum.value)>40){
      return 'جيد😊';
    }else if( double.parse(TotalSum.value)>20){
      return 'وسط 😒';
    }else {
      return 'ضعيف😢';
    }

  }

  /// ✅ تخزين معلومات المستخدم في Firestore
  Future<void> storeUserInfo({
    required String uid,
    required String name,
    required String? birthDate,
    required String? ageGroup,
    required String? gender,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'birthDate': birthDate,
        'ageGroup': ageGroup,
        'gender': gender,
        'gamesCompleted': 0,
        'starsEarned': 0,
        'testGame': '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حفظ البيانات');
      print('Error storing user info: $e');
    }
  }

  /// ✅ التوجه للشاشة الرئيسية بعد التسجيل
  void goToHomeIfRegistered(User user) {
    Get.offAll(() => MainChildPage());
  }

  /// ✅ جلب بيانات المستخدم من Firestore
  Future<Map<String, dynamic>?> getUserDataFromFirestore() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          return doc.data();
        } else {
          print('No data found for user with UID: ${user.uid}');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  /// 🚪 تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login'); // توجيه المستخدم إلى صفحة تسجيل الدخول
      Get.snackbar('تم', 'تم تسجيل الخروج بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء محاولة تسجيل الخروج');
      print('Error signing out: $e');
    }
  }

  /// ✅ جلب بيانات المستخدم وربطها بالمتغيرات Rx
  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          fullName.value = userDoc['name'] ?? 'مستخدم';
          
          ageGroup.value = userDoc['ageGroup'] ?? ''; // ✅ بدل int
          gender.value = userDoc['gender'] ?? 'غير محدد';
        
          
          scourAnimal.value=await getScore('AnimalMemoryGame');
          scourProf.value=await getScore('JobsMatchingGame');
          scourShape.value=await getScore('ShapeMatchingGame');
          scourLitter.value=await getScore('LetterQuiz');
          scourSens.value=await getScore('SensesQuiz');
          scourSeason.value=await getScore('SeasonsMatchingGame');
          scourNum.value=await getScore('NumbersMatchingGame');
          scourColor.value=await getScore('ColorQuiz');
          TotalSum.value=getSum();
          Taqdeer.value=getTaqdeer();
        
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

}

 
