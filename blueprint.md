# Project Blueprint

## Overview

This project is a Flutter application that helps users manage their investment buckets. It provides a dashboard to visualize their buckets and the stocks within them.

## Style and Design

The application follows the Material Design 3 guidelines, with a clean and modern user interface. It uses the `google_fonts` package for typography and `provider` for state management.

### Themes

The application supports both light and dark themes. The `ThemeProvider` class manages the theme state, and the `ColorScheme.fromSeed` is used to generate harmonious color palettes.

### Typography

The application uses the following fonts from `google_fonts`:
- `Oswald` for display and headlines
- `Roboto` for titles
- `Open Sans` for body text

## Features

### Welcome Screen

- An animated welcome screen that introduces the user to the application.
- It features a `PageView` with `AnimatedProjectCard` widgets that slide and fade in.
- A `SmoothPageIndicator` shows the current page.
- A "Get Started" button and a "Skip" button to navigate to the dashboard screen.

### Dashboard

- A dashboard screen that displays a list of investment buckets.
- Each bucket is represented by a `BucketCard` widget.
- Users can create new buckets by tapping the floating action button.

### Bucket Details

- A screen that shows the details of a specific bucket, including the stocks it contains.
- Users can add new stocks to the bucket.

### Create Bucket

- A screen that allows users to create a new investment bucket.
- It includes a form to enter the bucket name, description, and target amount.

## Current Task: Implement navigation from Welcome Screen to Dashboard

### Plan

1.  **Update `welcome_screen.dart`:**
    *   Add a "Skip" button to the top right of the screen.
    *   Implement a `_navigateToDashboard` function that uses `Navigator.of(context).pushReplacement` to navigate to the `DashboardScreen`.
    *   Call `_navigateToDashboard` when the "Get Started" or "Skip" button is pressed.
2.  **Update `blueprint.md`:** Reflect the changes made to the welcome screen.
