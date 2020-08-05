# smartrider 🚕

<img src="docs/screenshots/home.png" alt="home_screenshot" height="550px" align="right"/>

**The all-in-one RPI transportation app**

developed with [Flutter](https://flutter.dev/) and [Firebase](https://firebase.google.com/).

*Our goal is to make transportation in and around RPI safer and more intuitive.*

## Currently planned features:
- [ ] Allows you to call RPI saferide like uber.
- [x] Contains CDTA bus and RPI shuttle schedule.
    - [x] Allows you to search for specific departures.
    - [ ] Shows closest stops and estimated departure time in minutes.
- [x] Displays running routes on a map,
    - [ ] with live-update shuttle/bus locations.
- [x] Sexy UI
    - [x] Dark Mode
    - [x] Material Design
    - [x] 3D Map

Interact with our [mockups](https://xd.adobe.com/view/8a421d6f-ad6f-4196-7089-fff92621dc6f-fc73/?fullscreen)!

## Setting up (on Windows for Android Development)
1. Install the Flutter SDK and Android Studio.
    - Follow the steps at https://flutter.dev/docs/get-started/install/windows.
2. Setup your preferred editor for Flutter/Dart development. <br> (You can choose to develop in either VS Code or Android Studio, but in either case Android Studio is needed to install the android emulator)
    - Follow the steps at https://flutter.dev/docs/get-started/editor?tab=vscode.
3. Install an Android emulator.
    - Open Android Studio then open **Tools** -> **AVD Manager** -> **Create Virtual Device**
    - We recommend choosing Pixel 3 and Android Pie/9.0
    - To enable hardware acceleration (not required but recommended)
        - For Intel CPUs: Enable Intel Virtualization Technology in BIOS
        - For AMD CPUs: Enable the Windows Hypervisor Platform in Windows Features
4. Clone the smartrider repo with `git clone https://github.com/sirmammingtonham/smartrider.git`.
5. Download the `google-services.json` from the Firebase Android project and place it in the `android/app` folder.
6. Open Start Menu Search (windows key), type in `env`, and choose `Edit the system environment variables`.
    - Create a new environment variable by going to  `User variables for ...` and clicking `New...`
    - Under `Variable name` type `MAPS_API_KEY`, and enter the google maps api key for the value. Click `OK`.
    - (note: you have to restart your pc for these changes to take effect)
7. Download the required packages by following the steps in your editor of choice, or by running `flutter pub get` inside the cloned repository folder.
8.  Open the emulator and run `lib/main.dart` in your editor, or run `flutter run` in the repo folder.

## Setting up (on Windows for iOS Development)
1. Follow the same steps to set up on windows for android development.
2. To sign the app for installation on iOS, follow the steps [here](https://medium.com/flutter-community/how-to-sign-flutter-apps-for-ios-automatically-without-a-mac-a2dc9cfa5a6c) to sign with Codemagic. (Note: You will need a Codemagic account and an Apple Developer Account)

## Setting up (on Mac for Android Development)
1. Install the Flutter SDK and Android Studio.
    - Follow the steps at https://flutter.dev/docs/get-started/install/macos
2. Setup your preferred editor for Flutter/Dart development. (You can choose to develop in either VS Code or Android Studio, but in either case Android Studio is needed to install the android emulator)
    - Follow the steps at https://flutter.dev/docs/get-started/editor?tab=vscode.
3. Install an Android emulator.
    - Open Android Studio then open **Tools** -> **AVD Manager** -> **Create Virtual Device**
    - We recommend choosing Pixel 3 and Android Pie/9.0
    - To enable hardware acceleration (not required but recommended)
        - For Intel CPUs: Enable Intel Virtualization Technology in BIOS
4. Clone the smartrider repo with `git clone https://github.com/sirmammingtonham/smartrider.git`.
5. Download the `google-services.json` from the Firebase Android project and place it in the `android/app` folder.
6. Copy and rename `android/app/src/main/res/api-keys.template` to `android/app/src/main/res/values/api-keys.xml` (Don't delete the template file!)
    - Copy the API key for the Google Maps SDK from your Google Developers Console project and add it to `android/app/src/main/res/values/api-keys.xml`.
7. Create a file named `strings.dart` in the `lib/util` folder.
    - Add the line `const google_api_key = "KEY_HERE";` and replace `KEY_HERE` with the same API key for Google Maps.
8. Download the required packages by following the steps in your editor of choice, or by running `flutter pub get` inside the cloned repository folder.
9. Open the emulator and run `lib/main.dart` in your editor, or run `flutter run` in the repo folder.
10. If you encounter any problems with installation on Mac, you can open an [issue](https://github.com/sirmammingtonham/smartrider/issues).

## Setting up (on Mac for iOS Development)
1. Create an Apple developer account at https://developer.apple.com.
    - The process is free.
2. Setup your preferred editor for Flutter/Dart development. (VS Code is recommended)
    - Follow the steps at https://flutter.dev/docs/get-started/editor?tab=vscode.
3. Install Xcode >=11 from the app store, and run it once to initialize.
4. Configure Xcode by running the following commands in a terminal window:
    - `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
    - `sudo xcodebuild -runFirstLaunch`
5. Install the Flutter SDK and add it to your path.
    - Follow the steps at https://flutter.dev/docs/get-started/install/macos
6. Setup the iOS emulator.
    - Run simulator from spotlight or run `sudo xcodebuild -runFirstLaunch` from terminal.
7. Install and setup cocoapods by running the following commands from terminal.
    - `sudo gem install cocoapods` (**NOTE:** If you are getting an error when running this command run: `sudo xcode-select --switch /Library/Developer/CommandLineTools`)
    - `pod setup`
8. Clone the smartrider repo with `git clone https://github.com/sirmammingtonham/smartrider.git`.
9. Setup application signing by opening `ios/Runner.xcworkspace` in Xcode and selecting the blue Runner file.
    - Under the `Signing and Capabilities` tab, add and select your developer account.
10. Download the `GoogleService-info.plist` from the Firebase iOS project and link it through Xcode by:
    - Right clicking the `Runner` folder (not the blue one), and clicking `Add files to "Runner"`, then selecting the plist file.
11. Create a file named `ApiKeys.plist` in the `ios/Runner/` folder (through Xcode). Add the following:

        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>GOOG_API_KEY</key>
            <string>KEY_HERE</string>
        </dict>
        </plist>
    - and replace `KEY_HERE` with the API key for the Google Maps SDK from your Google Developers Console project.
12. Run `pod install` in the `ios/` folder.
13. Open the iOS simulator by running `open -a Simulator` in terminal, or by finding the app in Spotlight.
14. Debug the application through VS Code, or build it through Xcode.
    - If one doesn't work, try the other, or open an [issue](https://github.com/sirmammingtonham/smartrider/issues)!
    - NOTE: Due to a bug with iOS, you cannot test the app on physical iOS devices with software version 13.3.1 (see [here](https://github.com/flutter/flutter/issues/49504))
