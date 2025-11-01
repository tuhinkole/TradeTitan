# TradeTitan Blueprint

## Overview

TradeTitan is a Flutter application that allows users to browse and invest in different investment "buckets." Each bucket represents a curated portfolio of stocks based on a specific strategy or theme. The application provides a clean, modern, and responsive UI for viewing and interacting with these buckets.

## Style, Design, and Features

### Theming

*   **Color Scheme:** The app uses a modern color scheme based on Google's Material Design colors. The primary color is a deep blue, with accents of yellow and green. The app supports both light and dark modes.
*   **Typography:** The app uses the Poppins font from Google Fonts for a clean and modern look.
*   **Card Theme:** The cards have a custom theme with a "lifted" appearance, achieved through a combination of elevation, shadow, and rounded corners.

### UI Components

*   **BucketCard:** A custom widget that displays a summary of an investment bucket. It includes the bucket's name, rationale, top stocks, and key performance metrics (CAGR and volatility).
*   **StockRow:** A custom widget that displays a row of stock tickers within the `BucketCard`.

### Screens

*   **DashboardScreen:** The main screen of the application, which displays a responsive grid of `BucketCard` widgets. It also includes a search bar and sorting options.
*   **BucketDetailScreen:** A screen that displays the full details of a selected bucket.
*   **CreateBucketScreen:** A screen that allows users to create their own custom investment buckets.
*   **ProfileScreen:** A screen where users can manage their profile and authentication.
*   **InfoScreen:** A screen that provides additional information about the application.

### Features

*   **Responsive Layout:** The UI is designed to be responsive and adapt to different screen sizes, working well on both mobile and web.
*   **Light/Dark Mode:** The app includes a theme toggle to switch between light and dark modes.
*   **Firebase Integration:** The app is integrated with Firebase for data storage (Firestore) and user authentication.
*   **Search and Sort:** The `DashboardScreen` allows users to search for buckets by name or description and sort them by recency, minimum investment, or name.

## Current Plan: Production Optimization

The following actions have been taken to prepare the application for a production environment:

*   **Removed Unused Dependencies:** The `carousel_slider` package, which was part of a previous UI design, has been removed from the `pubspec.yaml` file.
*   **Removed Unused Code:** The `DashboardScreen` has been cleaned up to remove code related to the old carousel UI.
*   **Deleted Obsolete Files:** The following unused files have been deleted from the project:
    *   `lib/data/bucket_data.dart` (contains outdated mock data)
    *   `lib/presentation/screens/welcome_screen.dart` (unused onboarding screen)
    *   `lib/presentation/widgets/animated_project_card.dart` (unused UI component)
    *   `lib/presentation/widgets/bottom_bar.dart` (redundant UI component)

These changes result in a smaller, more optimized application, ready for deployment.
