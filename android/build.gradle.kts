 buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.0.2") // نسخة الـ Gradle Plugin، عدلها حسب النسخة عندك
        classpath("com.google.gms:google-services:4.3.15") // لازم للـ Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// لو عندك تخصيص لمكان بناء المشروع (اختياري)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
