buildscript {
    val kotlin_version by extra("1.8.10")  // Define the Kotlin version using 'extra'
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
        classpath("com.google.gms:google-services:4.3.13") // Google Services plugin

    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Add the Crashlytics Gradle plugin
    id("com.google.firebase.crashlytics")
    id("com.google.gms.google-services")
    //id("com.google.gms.google-services") // Google Services plugin
}

android {
    namespace = "com.kelvinht.movie_tv_level_maximum"
    compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kelvinht.movie_tv_level_maximum"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = flutter.minSdkVersion
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Core library desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")

    // Optional dependencies for window support
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")

    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-analytics")

    implementation("com.google.firebase:firebase-auth:21.0.1") // Firebase Authentication
    implementation("com.google.firebase:firebase-core:20.1.0")
}

flutter {
    source = "../.."
}
