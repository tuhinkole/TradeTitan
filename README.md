# TradeTitan

**TradeTitan** is a powerful and intuitive Flutter-based mobile application designed to simplify investment management. It allows users to create, manage, and track investment "buckets" — curated collections of stocks and assets tailored to specific financial strategies. With a sleek, modern interface and robust Firebase integration, TradeTitan provides a seamless experience for both novice and experienced investors to organize and monitor their portfolios.

## 1. Overview

TradeTitan is a mobile application built with Flutter that empowers users to take control of their investments. The core purpose of the app is to provide a platform where users can create personalized investment portfolios, known as "buckets," based on various strategies, risk levels, and financial goals. The app is designed for individuals who want a clear and organized way to manage their investments, track performance, and stay informed about their financial assets.

**Target Users:**
-   Individual investors who manage their own portfolios.
-   Financial enthusiasts who want to experiment with different investment strategies.
-   Users who need a simple yet powerful tool to track their assets across multiple categories.

## 2. Features

-   **Onboarding Experience:** A smooth and engaging onboarding process that introduces users to the app's main features.
-   **Dashboard:** A centralized view of all investment buckets, with options to search, sort, and filter.
-   **Create & Manage Buckets:** Users can create new investment buckets with detailed information, including:
    -   Bucket Name & Strategy
    -   Investment Manager & Rationale
    -   Minimum Investment Amount
    -   Volatility Level
    -   Stock Allocation & Holdings Distribution
-   **Dynamic Forms:** Add and remove stocks and holdings dynamically when creating or editing a bucket.
-   **Authentication:** Secure user authentication with options for email/password, anonymous sign-in, and registration, all powered by Firebase Auth.
-   **User Profiles:** A dedicated profile screen where users can view their authentication status and manage their account.
-   **Theme Toggle:** Switch between light and dark modes for a personalized viewing experience.
-   **Data Persistence:** All bucket data is securely stored and managed in real-time with Cloud Firestore.
-   **Responsive UI:** A clean and modern user interface that adapts to different screen sizes.

## 3. Tech Stack

-   **Frontend:** Flutter
-   **Backend:** Firebase
-   **Database:** Cloud Firestore
-   **Authentication:** Firebase Auth
-   **Styling:**
    -   `google_fonts`
    -   `provider` (for theme management)
-   **UI Components:**
    -   `carousel_slider`
    -   `smooth_page_indicator`
    -   `fl_chart`
-   **Development Tools:**
    -   `build_runner`
    -   `json_serializable`

## 4. Architecture

TradeTitan follows a layered architecture that separates the UI, business logic, and data layers, ensuring a clean and maintainable codebase.

-   **UI Layer:** Built with Flutter, the UI consists of various screens and widgets that provide the user interface. The `provider` package is used for state management, particularly for theme switching.
-   **Business Logic:** The core logic of the app, including creating, managing, and sorting buckets, is handled within the respective screen widgets and service classes.
-   **Data Layer:** The `services/firestore_service.dart` file abstracts the interaction with the Cloud Firestore database. It handles all CRUD (Create, Read, Update, Delete) operations for the investment buckets.
-   **Authentication:** Firebase Auth is integrated to manage user sign-in, registration, and anonymous access. The `profile_screen.dart` provides the UI for these authentication flows.

**Data Flow:**
1.  A user creates a new bucket on the `CreateBucketScreen`.
2.  The form data is used to create a `Bucket` object.
3.  The `FirestoreService` sends the `Bucket` object to the Cloud Firestore database.
4.  The `DashboardScreen` listens to a stream from `FirestoreService` to display the list of buckets in real-time.
5.  When a user signs in, their authentication state is managed by Firebase Auth, and the app's UI updates accordingly.

## 5. Installation / Setup Guide

To get the TradeTitan app running on your local machine, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/your-username/tradetitan.git
    cd tradetitan
    ```

2.  **Install Dependencies:**
    Make sure you have Flutter installed. Then, run the following command to fetch all the required packages:
    ```bash
    flutter pub get
    ```

3.  **Set Up Firebase:**
    -   Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    -   Follow the instructions to add a new Flutter app to your project.
    -   Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files and place them in the appropriate directories (`android/app` and `ios/Runner`).
    -   Enable **Cloud Firestore** and **Firebase Auth** in the Firebase Console.

4.  **Run the App:**
    Connect a device or start an emulator, and then run the following command:
    ```bash
    flutter run
    ```

## 6. Configuration

-   **Firebase Configuration:** All Firebase-related keys and settings are managed by the `google-services.json` and `GoogleService-Info.plist` files. No manual environment variable setup is required for the app to connect to Firebase.
-   **Theme Configuration:** The app's theme can be customized in `lib/main.dart`, where `lightTheme` and `darkTheme` are defined.

## 7. Usage

-   **End-Users:**
    -   Launch the app and go through the onboarding screens.
    -   On the dashboard, you can view existing investment buckets.
    -   Tap the "+" button to create a new bucket.
    -   Fill in the details for your bucket, including stocks and holdings.
    -   Use the search bar and filter options to find specific buckets.
    -   Navigate to the profile screen to sign in or register.
-   **Developers:**
    -   The code is organized into screens, widgets, services, and domain models.
    -   To add a new feature, you can create a new screen in the `lib/presentation/screens` directory and integrate it into the navigation flow.

## 8. Authentication & Security

Authentication is handled via **Firebase Auth**, which supports:
-   **Email/Password:** Users can sign up and sign in with their email and password.
-   **Anonymous Sign-In:** Users can access the app's features without creating an account.

All data is protected by **Firestore Security Rules**. By default, data is private, but you can configure the rules in `firestore.rules` to define access controls based on user authentication status.

## 9. APIs / Services

The app's primary backend service is **Cloud Firestore**. The `FirestoreService` class (`lib/services/firestore_service.dart`) provides the following methods:

-   `getBuckets()`: Returns a stream of all investment buckets.
-   `addBucket(Bucket bucket)`: Adds a new bucket to the database.

**Example Bucket Data (JSON):**
```json
{
  "name": "Tech Growth",
  "strategy": "High-growth tech stocks",
  "manager": "Jane Doe",
  "rationale": "Focus on innovative tech companies.",
  "minInvestment": 5000,
  "volatility": 0.8,
  "stockCount": 3,
  "rebalanceFrequency": "Annual",
  "lastRebalance": "2023-10-27T10:00:00.000Z",
  "nextRebalance": "2024-10-27T10:00:00.000Z",
  "allocation": {
    "AAPL": 0.4,
    "GOOGL": 0.3,
    "MSFT": 0.3
  },
  "holdingsDistribution": {
    "Technology": 0.9,
    "Other": 0.1
  }
}
```

## 10. Deployment

To deploy the TradeTitan app, you can follow the standard deployment procedures for Flutter applications:

-   **Android:**
    Build the release APK or AAB:
    ```bash
    flutter build apk --release
    flutter build appbundle --release
    ```
    Then, upload the generated file to the Google Play Store.

-   **iOS:**
    Build the release archive in Xcode and distribute it through the App Store.

-   **Web:**
    If you want to deploy the app as a web application, you can build it with:
    ```bash

    flutter build web
    ```
    Then, deploy the contents of the `build/web` directory to a web hosting service like Firebase Hosting.

## 11. Troubleshooting / FAQs

-   **Problem:** The app is not connecting to Firebase.
    -   **Solution:** Ensure that the `google-services.json` and `GoogleService-Info.plist` files are correctly placed in the project directories. Also, check that you have enabled Firestore and Auth in your Firebase project.
-   **Problem:** The app crashes on startup.
    -   **Solution:** Run `flutter doctor` to check for any issues with your Flutter installation. Make sure all dependencies are up-to-date by running `flutter pub get`.

## 12. Future Enhancements

-   **Portfolio Performance Tracking:** Add charts and graphs to visualize the performance of each bucket over time.
-   **Push Notifications:** Implement Firebase Cloud Messaging to send alerts about market changes or rebalancing reminders.
-   **User Data Sync:** Allow users to sync their data across multiple devices.
-   **Advanced Filtering:** Introduce more advanced filtering options, such as by risk level or asset class.

## 13. License & Credits

This project is licensed under the MIT License. See the `LICENSE` file for details.

**Credits:**
-   **Flutter:** The UI toolkit used to build the app.
-   **Firebase:** The backend platform that powers the app's database and authentication.
-   **Google Fonts:** For providing the custom fonts used in the app.
