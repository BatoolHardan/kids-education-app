 plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // إضافة خدمة Google Firebase
    // يجب أن يكون الـ Flutter Plugin آخر واحد
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.test0"
    compileSdk = 35 // أو flutter.compileSdkVersion حسب نسختك
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.test0"
        minSdk = 23 // أو flutter.minSdkVersion
        targetSdk = 35 // أو flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // للتجربة فقط
        }
    }
}

flutter {
    source = "../.."
}
