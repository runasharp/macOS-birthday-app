# macOS Birthday App 🎉

This is a macOS app for managing and remembering your friends' birthdays. The app supports adding, editing, and displaying birthdays using SwiftUI, and also includes a macOS widget to showcase upcoming birthdays.

## Features
- Add and edit friends' details (including photos, names, and birthdays).
- Sort and display upcoming birthdays.
- Widget support for quick access to upcoming birthdays.
- Data persistence (between the app & the widget) using Core Data.

## Requirements
- **macOS 13.0+**
- **Xcode 14.0+**
- **Swift 5.7+**

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/runasharp/macOS-birthday-app.git
   ```
2. Open the project in Xcode:
   ```bash
   cd macOS-birthday-app
   open BirthdayApp.xcodeproj
   ```
3. Build and run the app using the Xcode toolbar.

## How to Use
1. **Add a Friend:**  
   Click the "+" button to add a friend's name, birthday, and photo.  
2. **Edit a Friend:**  
   Click the pencil icon next to a friend's name to edit their details.  
3. **View Upcoming Birthdays:**  
   The app will display a sorted list of upcoming birthdays along with the number of days remaining.  
4. **Widget:**  
   Enable the widget to view the next three upcoming birthdays directly from your desktop.

## Widget Configuration
- The widget shows upcoming birthdays, sorted by the number of days left.
- Widget uses the same Core Data storage as the main app, ensuring data consistency.

