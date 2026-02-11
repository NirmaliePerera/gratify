# Gratify 🌸

*A Privacy-First Gratitude Journaling App Built with Flutter*

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![Database](https://img.shields.io/badge/Database-SQLite-orange)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📖 Overview

**Gratify** is a mobile gratitude journaling application built using Flutter.
It allows users to record daily reflections, track emotional states, and review past entries through an intuitive calendar interface.

The app is designed with a **privacy-first approach** — all data is stored locally on the device using SQLite.

---

## ✨ Core Features

### 🔐 Secure Passcode Authentication

* First-time passcode setup
* Login using passcode
* Reset passcode
* Logout functionality
* Encrypted local storage

### 📝 Journal Entries

* Add gratitude notes
* Assign a mood rating:
  * 😊 Happy
  * 🙂 Content
  * 😔 Sad
  * 😴 Tired
  * 😠 Angry
* Edit journal text (only text for now, mood remains unchanged)
* Delete entries

### 📅 Calendar View

* Calendar-based navigation
* Visual indicators (dots) for dates with entries
* Tap a date to view note details and mood

### 📩 Feedback Support

* Direct phone call support (2 contact numbers)
* Email feedback option (opens default mail app)

---

## 🏗️ Tech Stack

| Layer               | Technology                      |
| ------------------- | ------------------------------- |
| Framework           | Flutter                         |
| Language            | Dart                            |
| Database            | sqflite (SQLite local database) |
| Local Storage       | shared_preferences              |
| Encryption          | crypto, pointycastle            |
| UI Styling          | google_fonts                    |
| External App Launch | url_launcher                    |

---

## 📂 Project Structure (Simplified)

```
lib/
 ├── models/
 ├── db/
 ├── screens/
 ├── widgets/
 └── main.dart
```

---

## 🔒 Privacy Design

Gratify intentionally avoids cloud storage.

* No backend server
* No cloud database
* No analytics tracking
* Fully offline functionality
* Data stored locally via SQLite

This ensures user reflections remain private and secure.

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/NirmaliePerera/gratify.git
cd gratify
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Run the App

```bash
flutter run
```

### 4️⃣ Build Release APK

```bash
flutter build apk --release
```

APK Output:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Important Dependencies

```yaml
google_fonts
sqflite
shared_preferences
url_launcher
crypto
pointycastle
```

---

## 📱 Screens

* Splash Screen
* Set Passcode
* Login
* Home Screen
* Add Notes
* View Notes (Calendar View)
* Note Details
* Edit Note (Dialog)
* Send Feedback 

---

## 🛠 Future Enhancements

* Edit moods
* Mood analytics dashboard
* Dark mode
* Biometric authentication
* Encrypted backup & restore
* Push notifications / reminders

---

## 👩‍💻 Author

**Nirmalie Perera**

---

## 📜 License

This project is open-source under the MIT License.
