# AgiBank-TravelLog
This project will be used to teach SwiftUI in an immersion program for AgiBank students. It will be an application for making reservations, checking information about currencies, travel, schedules, flights, and hotels, among other things.


# Firebase Setup for AgiBank-TravelLog

1. Firebase Console
   - Create a Firebase project.
   - Enable Authentication -> Sign-in method -> Email/Password.
   - Add an iOS app and register your bundle identifier.
   - Download `GoogleService-Info.plist` and add it to the project (Xcode Project Navigator, ensure target is checked).

2. Install Firebase (Swift Package Manager)
   - File > Add Packages...
   - URL: `https://github.com/firebase/firebase-ios-sdk`
   - Add `FirebaseCore` and `FirebaseAuth` packages to your app target.

3. App Configuration
   - Ensure `FirebaseApp.configure()` is called early in app launch.
   - Example: add call in the App struct `init()` (see AppMain.swift).

4. Use the provided files
   - Add `AuthViewModel.swift`, `LoginView.swift`, `RegisterView.swift`, `ForgotPasswordView.swift`, `ContentView.swift`, and update your `App` entry point as shown.

5. Testing
   - Run the app in a simulator or device.
   - Register a new user (Email/Password).
   - Sign in using the user.
   - Use "Forgot Password" to send a reset email.

Notes
- Password min length for Email/Password in Firebase is typically 6 chars.
- If you want email verification flows, after createUser call `user.sendEmailVerification()` and enforce checking `user.isEmailVerified`.
- For production, add error mapping and user-friendly messages, plus secure password rules and UX flows.

# Access documentation
 - control command shift d
