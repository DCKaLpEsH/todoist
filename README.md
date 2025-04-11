# Todoist

A beautiful, feature-rich todo list application built with Flutter. This application helps you manage your tasks with a clean, modern interface and smooth animations.

## Features

### Task Management

- **Create tasks**: Add new todos with a floating action button
- **Edit tasks**: Double-tap or click the edit icon to modify task details
- **Complete tasks**: Mark tasks as done with a beautiful animated checkbox
- **Delete tasks**: Swipe tasks to remove them from your list
- **Clear completed**: Remove all completed tasks with one button

### Organization & Filtering

- **Filtering system**: Toggle between All, Active, and Completed tasks
- **Status tracking**: View counts of total, active, and completed tasks
- **Visual indicators**: Different styling for active vs completed tasks

### User Experience

- **Smooth animations**: Enjoy fluid transitions and microinteractions throughout the app
- **Haptic feedback**: Feel subtle vibrations when interacting with the app
- **Empty states**: Helpful messages when lists are empty
- **Swipe actions**: Use gestures for quick task management

### Technical Features

- **Local storage**: All todos are saved locally on your device
- **State management**: Uses Provider for efficient state handling
- **Theme support**: Beautiful light and dark mode themes
- **Responsive design**: Works on various screen sizes

## Stats and Data

The app maintains various statistics about your todos:

- **Total count**: Number of all tasks in the system
- **Active count**: Number of incomplete tasks
- **Completed count**: Number of finished tasks

These stats are displayed in the filter buttons, making it easy to see your progress at a glance.

## Architecture

The app follows a Simple pattern:

- **models**: Data structures for todos and other entities
- **providers**: State management using the Provider pattern
- **presentation**: Main UI containers for the application
- **presentation/widgets**: Reusable UI components
- **presentation/theme**: Helper functions and theme definitions

## Persistence

All todo items are automatically saved to local storage using SharedPreferences. Your data persists between app launches, so you never lose your task list.

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Launch with `flutter run`

## Dependencies

- **provider**: For state management
- **shared_preferences**: For local storage
- **uuid**: For generating unique IDs
- **google_fonts**: For custom typography
- **flutter/material.dart**: For Material Design components
