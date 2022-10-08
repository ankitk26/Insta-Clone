
# InstaClone

An Instagram clone built using Flutter and Firebase

[<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />](https://flutter.dev/)  [<img src="https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase" />](https://firebase.flutter.dev/)

![App Screenshot](https://res.cloudinary.com/drnu1myuq/image/upload/v1648292595/design_emvq9l.png)


## Run Locally

To run the project, Flutter must be installed in the system. Click [here](https://docs.flutter.dev/get-started/install) to install Flutter if not installed:

Run the command below in the terminal to check if Flutter is installed successfully. If no error shows up, proceed further.

```bash
flutter --version
```

**Step 1: Clone the project**

```bash
git clone https://github.com/ankitk26/Insta-Clone.git
```

**Step 2: Go to the project directory**

```bash
cd my-project
```

**Step 3: Install dependencies**

```bash
flutter pub get
```

**Step 4: Add Firebase**

Add the Firebase credentials to the project using the given [link](https://firebase.google.com/docs/flutter/setup?platform=android):

**Step 5: Run the project**

Run the project either by starting debugging or using the command given below

```bash
flutter run
```

## Features

- Splash screen
- Custom app launcher icon
- Login/Register with validation
- View all posts of users followed by you in the feed
- Upload a post
- View a single post
- Edit or delete your posts
- Like, comment, or save a post
- Edit or delete your comments
- Follow or unfollow other users
- Edit your profile
- Image upload for posts and avatar
- App currently in dark mode only

### To-do features
- Send a request to a user to view their posts in the feed
- Toggling theme
- Push notification when someone comments or sends a request
- In-app chat
- Search user by username
- Upload multiple images and videos
- Display original user's details for a reposted post

## Folder structure

The folder structure used in the project is shown below:

```
lib/
|- models/
|- providers/
|- screens/
|- services/
|- utils/
|- widgets/
|- main.dart
```

Each folder is described below:

* `models` - Contains the blueprints of each model used - User, Post, and Comment.
* `providers` - Contains the providers used for state management across the app. All of these are ChangeNotifier providers.
* `screens` - Contains the root of each screen which consists of different widgets. 
* `services `  -  Contains functions to read and write data to the database.
* `utils`  -  Contains constants and utility functions of the app.
* `widgets ` - Contains reusable widgets or widgets to make the code modular.
* `main.dart` - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, etc.

## Dependencies used

All the dependencies used can be found in `pubspec.yaml` file in root folder. The usage of each dependency is listed below:

* [`firebase_auth`](https://pub.dev/packages/firebase_auth) - manages authentication (login, signup and logout) in the app using Firebase authentication.
* [`cloud_firestore`](https://pub.dev/packages/cloud_firestore) - read and write data to Firebase Firestore.
* [`firebase_storage`](https://pub.dev/packages/firebase_storage) - save images of posts and avatars in cloud storage provided by Firestore.
* [`provider`](https://pub.dev/packages/provider) (10.2.9) - manage state in the app
* [`url_launcher`](https://pub.dev/packages/url_launcher) - launch a url in browser after clicking a link in the app
* [`intl`](https://pub.dev/packages/intl) (0.17.0) - handle dates.
* [`masonry_grid`](https://pub.dev/packages/masonry_grid) (1.0.0) - display images in a grid.
* [`image_picker`](https://pub.dev/packages/image_picker) (0.8.4+10) - select images from gallery or capture a new image from camera.
* [`flutter_image_compress`](https://pub.dev/packages/flutter_image_compress) (1.1.0) - compress the image before uploading it to Firebase cloud storage.
* [`cached_network_image`](https://pub.dev/packages/cached_network_image) (3.2.0) - caches network images and provides placeholder while the image loads.
* [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) (0.9.2) - updating app's launcher icon

## References

- [Firebase for Flutter](https://firebase.flutter.dev/)
 - [Adding splash screen to Flutter app](https://www.youtube.com/watch?v=JVpFNfnuOZM)
 - [Firebase authentication](https://www.youtube.com/watch?v=oJ5Vrya3wCQ)
 - [Add launcher icon](https://www.youtube.com/watch?v=O9ChjwrZqns)

