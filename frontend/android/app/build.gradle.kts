import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 환경 변수를 저장할 맵 생성
val dartEnvironmentVariables = mutableMapOf<String, String?>(
    "KAKAO_NATIVE_APP_KEY" to null
)

// .env 파일 읽기
try {
    val envFile = project.file("../../.env")
    if (envFile.exists()) {
        envFile.readLines().forEach { line ->
            if (line.isNotEmpty() && !line.startsWith("#")) {
                val parts = line.split("=", limit = 2)
                if (parts.size == 2) {
                    val key = parts[0].trim()
                    val value = parts[1].trim().replace("\"", "")  // 따옴표 제거
                    
                    // 환경 변수를 맵에 할당
                    if (key == "KAKAO_NATIVE_APP_KEY") {
                        dartEnvironmentVariables["KAKAO_NATIVE_APP_KEY"] = value
                    }
                }
            }
        }
    }
} catch (e: Exception) {
    println("Error reading .env file: ${e.message}")
}

// keystore 설정
val keystoreProperties = Properties().apply {
    val keystoreFile = rootProject.file("key.properties")
    if (keystoreFile.exists()) {
        load(FileInputStream(keystoreFile))
    }
}

android {
    namespace = "com.example.frontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        multiDexEnabled = true
    }

    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.yoplay.prana"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["Prana"] = "io.flutter.app.FlutterApplication"
        manifestPlaceholders["KAKAO_NATIVE_APP_KEY"] = dartEnvironmentVariables["KAKAO_NATIVE_APP_KEY"] ?: ""
    }

    println("🧪 DEBUG keystore properties")
    println("keyAlias: ${keystoreProperties["keyAlias"]}")
    println("keyPassword: ${keystoreProperties["keyPassword"]}")
    println("storePassword: ${keystoreProperties["storePassword"]}")
    println("storeFile: ${keystoreProperties["storeFile"]}")

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isShrinkResources = false
            isMinifyEnabled = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("androidx.work:work-runtime-ktx:2.10.0")
}

flutter {
    source = "../.."
}