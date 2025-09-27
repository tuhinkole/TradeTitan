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
- A stylish, fixed header (`AppBar`) with a gradient background that adapts to light and dark modes.
- Each bucket is represented by a `BucketCard` widget.
- Users can create new buckets by tapping the floating action button.

### Bucket Details

- A screen that shows the details of a specific bucket, including the stocks it contains.
- Users can add new stocks to the bucket.

### Create Bucket

- A stylish and comprehensive screen for creating a new investment bucket.
- The form is organized into logical sections: "Bucket Information", "Configuration", "Stocks & Allocation", and "Holdings Distribution".
- All fields are validated with clear error messages, and required fields are marked with an asterisk (*).
- Includes fields for bucket name, strategy, manager, rationale, minimum investment, rebalance frequency, rebalance dates, and volatility.
- Dynamically add and remove stock and holding allocation fields.

## Current Task: Implement a Comprehensive "Create Bucket" Screen

### Plan

1.  **Update `create_bucket_screen.dart`:**
    *   Implemented a `Form` with a `GlobalKey` for validation.
    *   Added `TextFormField` widgets for all text-based fields from the `Bucket` model.
    *   Included a `DropdownButtonFormField` for rebalance frequency, `DatePicker` for rebalance dates, and a `Slider` for volatility.
    *   Created dynamic sections for adding/removing stocks and holdings, each with its own form validation.
    *   Styled all form fields for a modern and consistent look, with icons and custom borders.
    *   Implemented the `_saveBucket` function to validate all forms and create a `Bucket` object.
2.  **Update `blueprint.md`:** Reflect the implementation of the comprehensive "Create Bucket" screen.
