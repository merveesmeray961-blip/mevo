import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Yükleme anahtarı bilgileri android/key.properties içindedir (git'e girmez). Dosya yoksa
// yayın derlemesi hata ayıklama anahtarıyla imzalanır: yalnızca yerelde denemek içindir, mağazaya yüklenemez.
val anahtarDosyasi = rootProject.file("key.properties")
val anahtarBilgisi = Properties().apply {
    if (anahtarDosyasi.exists()) anahtarDosyasi.inputStream().use { load(it) }
}

android {
    namespace = "app.mevo.smmm"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "app.mevo.smmm"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // versionCode ve versionName pubspec.yaml'daki `version: 1.0.0+1` satırından gelir.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (anahtarDosyasi.exists()) {
            create("yayin") {
                keyAlias = anahtarBilgisi.getProperty("keyAlias")
                keyPassword = anahtarBilgisi.getProperty("keyPassword")
                storeFile = file(anahtarBilgisi.getProperty("storeFile"))
                storePassword = anahtarBilgisi.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("yayin") ?: signingConfigs.getByName("debug")
            // Küçültme/gizleme (R8) ve kullanılmayan kaynakların atılması.
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
