// import java.util.Properties
// import java.io.FileInputStream

// plugins {
//     id("com.android.application")
//     id("com.google.gms.google-services")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
// }

// dependencies {
//     implementation(platform("com.google.firebase:firebase-bom:33.15.0"))
//     implementation("com.android.support:multidex:1.0.3")
//     implementation("com.google.android.material:material:1.12.0")
//     implementation("com.google.firebase:firebase-analytics")
//     implementation("androidx.window:window:1.0.0")
//     implementation("androidx.window:window-java:1.0.0")
//     coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
// }

// val keystoreProperties = Properties()
// val keystorePropertiesFile = rootProject.file("key.properties")
// if (keystorePropertiesFile.exists()) {
//     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
// }

// android {
//     namespace = "com.harsh.adhikar"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = "27.0.12077973"

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_11
//         targetCompatibility = JavaVersion.VERSION_11
//         isCoreLibraryDesugaringEnabled = true
//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_11.toString()
//     }

//     defaultConfig {
//         applicationId = "com.harsh.adhikar"
//         minSdk = flutter.minSdkVersion
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//         multiDexEnabled = true
//     }
    
//     signingConfigs {
//         create("release") {
//             if (keystorePropertiesFile.exists()) {
//                 keyAlias = keystoreProperties["keyAlias"] as String
//                 keyPassword = keystoreProperties["keyPassword"] as String
//                 storeFile = file(keystoreProperties["storeFile"] as String)
//                 storePassword = keystoreProperties["storePassword"] as String
//             }
//         }
//     }

//     buildTypes {
//         getByName("release") {
//             signingConfig = if (keystorePropertiesFile.exists()) {
//                 signingConfigs.getByName("release")
//             } else {
//                 signingConfigs.getByName("debug")
//             }
//             isShrinkResources = true
//             isMinifyEnabled = true
//             proguardFiles(
//                 getDefaultProguardFile("proguard-android-optimize.txt"),
//                 "proguard-rules.pro"
//             )
//         }
//     }
// }

// flutter {
//     source = "../.."
// }



plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

  implementation("com.android.support:multidex:1.0.3")

  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")
  implementation("androidx.window:window:1.0.0")
  implementation("androidx.window:window-java:1.0.0")
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "com.example.adhikar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.harsh.adhikar"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("debug")
        isShrinkResources = true
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}

}

flutter {
    source = "../.."
}