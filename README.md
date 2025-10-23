# golden_experience

A money management app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## .gitignored setup

### Signing Key

1. Prepare the keystore
   - Utilize the previously configured key if available
   - Create a new key otherwise
      - `keytool -genkey -v -keystore {your-keystone-output|~/upload-keystore.jks} -keyalg RSA -keysize 2048 -validity 10000 -alias {your-alias|upload}`
2. Reference the keystore on the android app
   - Create the file `./android/key.properties` with content:
      - ```properties
         storePassword={your-password-from-step-1}
         keyPassword={your-password-from-step-1}
         keyAlias={your-alias-from-step-1}
         storeFile={keystore-location|H:\\Code\\release-key.jks}
         ```
3. Configure signing in Gradle
   - Edit `./android/app/build.gradle.kts`
   - Add imports and load the keystore properties file before the `android` block:
      - ```kotlin
         import java.util.Properties
         import java.io.FileInputStream

         val keystoreProperties = Properties()
         val keystorePropertiesFile = rootProject.file("key.properties")
         if (keystorePropertiesFile.exists()) {
             keystoreProperties.load(FileInputStream(keystorePropertiesFile))
         }
         ```
   - Add the signing configuration inside the `android` block, before `buildTypes`:
      - ```kotlin
         signingConfigs {
             create("release") {
                 keyAlias = keystoreProperties["keyAlias"] as String
                 keyPassword = keystoreProperties["keyPassword"] as String
                 storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                 storePassword = keystoreProperties["storePassword"] as String
             }
         }
         ```
   - Update the `release` buildType to use the signing configuration:
      - ```kotlin
         buildTypes {
             release {
                 signingConfig = signingConfigs.getByName("release")
             }
         }
         ```
   - Run `flutter clean` to avoid cached builds interfering with signing