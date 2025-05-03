plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Must be after Android/Kotlin
}

android {
    namespace = "com.example.voice_rec_app"
    compileSdk = 35 // or your target SDK version
    ndkVersion = "27.0.12077973" // ✅ updated NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.voice_rec_app"
        minSdk = 24 // ✅ Updated from flutter.minSdkVersion to 24
        targetSdk = 35 // or your current target SDK
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
