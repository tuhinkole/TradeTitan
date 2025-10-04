# TradeTitan Blueprint

## Overview

TradeTitan is a Flutter application that allows users to create, manage, and track investment buckets. It provides a modern and intuitive user interface for managing investment portfolios.

## Features

- **Create, Read, Update, and Delete (CRUD) Buckets:** Users can create new investment buckets, view a list of their buckets, and delete buckets they no longer need.
- **Firestore Integration:** The application uses Firebase Firestore to store and manage investment bucket data.
- **Visually Appealing UI:** The application features a modern and visually appealing user interface with a glassmorphism effect, custom fonts, and an animated chart.
- **Responsive Design:** The application is designed to be responsive and work well on both mobile and web platforms.

## Style and Design

- **Glassmorphism:** The application uses the `glassmorphism` package to create a frosted glass effect on the bucket cards.
- **Custom Fonts:** The application uses the `google_fonts` package to apply the "Roboto" and "Oswald" fonts for a more modern and readable typography.
- **Animated Chart:** The application uses the `fl_chart` package to display an animated and interactive line chart for visualizing investment returns.
- **Theming:** The application supports both light and dark themes, with a custom color scheme and text styles.

## Project Structure

```
lib
├── data
│   └── bucket_data.dart
├── domain
│   └── bucket.dart
├── presentation
│   ├── screens
│   │   ├── bucket_detail_screen.dart
│   │   ├── create_bucket_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── welcome_screen.dart
│   └── widgets
│       └── bucket_card.dart
├── services
│   └── firestore_service.dart
└── main.dart
```
