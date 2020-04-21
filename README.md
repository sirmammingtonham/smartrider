# smartrider 🚕
**The all-in-one RPI transportation app**

developed with [Flutter](https://flutter.dev/) and [Firebase](https://firebase.google.com/).

*Our goal is to make transportation in and around RPI safer and more intuitive.*

## Currently planned features:
* Allows you to call RPI saferide like uber.
* Contains CDTA bus and RPI shuttle schedule.
  * And estimated map
* Sexy UI

Interact with our [mockups](https://xd.adobe.com/view/8a421d6f-ad6f-4196-7089-fff92621dc6f-fc73/?fullscreen)!

## Setting up (on Windows for Android Development)
1. Install the Flutter SDK and Android Studio.
    - Follow the steps at https://flutter.dev/docs/get-started/install/windows.
2. Setup your preferred editor for Flutter/Dart development. (You can choose to develop in either VS Code or Android Studio, but in either case Android Studio is needed to install the android emulator)
    - Follow the steps at https://flutter.dev/docs/get-started/editor?tab=vscode.
3. Install an Android emulator.
    - Open Android Studio then open **Tools** -> **AVD Manager** -> **Create Virtual Device**
    - We recommend choosing Pixel 3 and Android Pie/9.0
    - To enable hardware acceleration (not required but recommended)
        - For Intel CPUs: Enable Intel Virtualization Technology in BIOS
        - For AMD CPUs: Enable the Windows Hypervisor Platform in Windows Features
4. Clone the smartrider repo with `git clone https://github.com/sirmammingtonham/smartrider.git`.
5. Download the `google-services.json` from the Firebase project and place it in the `android/app` folder.
6. Copy and rename `android/app/src/main/res/api-keys.template` to `android/app/src/main/res/values/api-keys.xml` (Don't delete the template file!)
    - Copy the API key for the Google Maps SDK from your Google Developers Console project and add it to `android/app/src/main/res/values/api-keys.xml`.
7. Create a file named `strings.dart` in the `lib/util` folder.
    - Add the line `const google_api_key = "KEY_HERE";` and replace `KEY_HERE` with the same API key for Google Maps.
8. Download the required packages by following the steps in your editor of choice, or by running `flutter pub get` inside the cloned repository folder.
9. Open the emulator and run `lib/main.dart` in your editor, or run `flutter run` in the repo folder.

## Setting up (on Windows for iOS Development)
1. Follow the same steps to set up on windows for android development.
2. To sign the app for installation on iOS, follow the steps [here](https://medium.com/flutter-community/how-to-sign-flutter-apps-for-ios-automatically-without-a-mac-a2dc9cfa5a6c) to sign with Codemagic. (Note: You will need a Codemagic account and an Apple Developer Account)

## Setting up (on Mac for iOS Development)
1. Working on it...
