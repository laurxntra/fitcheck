# FitCheck

## Description
Our app is designed to make fashion fun by gamifying everyday style and inspiring creativity. Here’s how it works: each night, users receive a theme for the next day’s outfit- think “red” or “denim.” The next day, they share photos of their outfits, and friends vote on who nailed the theme best. It’s like “BeReal,” but for outfits, with a competitive twist.

## [Living Document](https://docs.google.com/document/d/1CZu642kOHpgtLdXkNPS8U6OsxPTkgixnqs-X6VRMPes/edit?tab=t.0)

COMPLETED FEATURES:
==================================================================================================================
- User Authentication System
  * Allow users to create accounts, log in, and log out.
  * Include user profile picture and username.
  
- Daily Outfit Challenges (P0)
  * Display the daily "piece of clothing/theme" challenge.
  * Allow users to submit photos of themselves wearing the outfit within the specified time limit.
 
- DataBase
  * Holds all user’s posts and account information (followers, following, number of posts, username) 
  * Stores all of today’s posts for viewing on friend’s pages
  * Stores all of user’s posts to date to view on profile
 
- Awarding System
  * Users are able to award hearts to a post
  * Awards aare kept track of in leaderboard
  * Awards are restricted on a per day basis
 
- Leaderboard and Point Icons (P1) 
  * Display a leaderboard based on the top three best dressed and/or awarded people and have certain icons and levels based on how many hearts a user has.

- Searching for Friends’ posts (P2)
  * Users can type in the username of a friend and view a page showing that friend’s post for today. If the friend has not posted today, it shows their account    
  * information (username, number of followers, number of friends, number of posts to date).

- Functional OTP/account creation
- Functional backend (data storage/retreival)

  -------------------
CURRENT SATISFIED USE CASE:
Goal:
- Posting the daily photo of your fit!
Actors:
- Primary Actor - The user taking the photo. 
- Database - Stores users photos. 
- Backend - Processes photo. 
Triggers:
- User opens the app and views the “FitPiece” of the day, presses the camera button to take a photo of them in their fit or upload a photo. 
Preconditions:
- User is signed in to the app. 
- Daily challenge is open and active.
Postconditions (success scenario):
- Photo is successfully uploaded in the database and processed by the backend.
- From there, the user can view their photo, and like/comment.



TO RUN:

Prerequisites
__________________
Ensure you have the following installed:
- Flutter SDK
- Dart
- Android Studio or Visual Studio Code (with Flutter extensions)
- Xcode (for iOS development)
  
Setup
__________________
Clone the repository:
- git clone <repository_url>
- cd flutter_app
Install dependencies:
- flutter pub get

Build Instructions
- For Android:
  - flutter build apk
For iOS:
  - flutter build ios

Testing Instructions
______________________
Run unit and widget tests:
  - flutter test

Running the App
__________________
For Android Emulator (Android Studio):
- flutter run
For iOS Simulator:
- flutter run -d ios
For a connected physical device:
- flutter run -d <device_id>

Folder Structure
__________________
flutter_app/
│── lib/                 # Main application code

│   ├── main.dart        # Entry point of the application (view posts)

│   ├── screens/         # UI screens of the app

│   ├── widgets/         # Reusable widgets

│   ├── services/        # API and business logic services

│── assets/              # Static assets (images, fonts, etc.)

│── test/                # Unit and widget tests

│── pubspec.yaml         # Flutter project configuration and dependencies

│── android/             # Android-specific configuration

│── ios/                 # iOS-specific configuration

│── web/                 # Web-related files (if applicable)

│── README.md            # Project documentation

## 📌 Beta++ Release

This is the **Beta++ release** of FitCheck, including all current documentation and features.

**Release Tag:** [v2.0-final release](https://github.com/chaafenr/fitcheck/releases/tag/v1.0-beta++)  
**Last Commit Date: 3/11/2025

-> README.md 
