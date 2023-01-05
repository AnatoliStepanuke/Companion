# Companion
Дипломный проект на тему: "Программное обеспечение для мобильных устройств на платформе iOS для коммуникации между студентами и преподавателями".

## Technologies
+ UIKit
+ MVC
+ Firebase
  + Auth
  + Database
  + Storage
+ Grand Central Dispatch
+ UserDefaults
+ Swift Package Manager

## Installation
[Swift Package Manager](https://www.swift.org/package-manager/) lets you manage your project dependencies, allowing you to import libraries into your applications.
To integrate [Firebase](https://firebase.google.com) into your Xcode project using SPM, follow install steps below:
1. Select **File > Add Packages...**
2. Add the Github [URL](https://github.com/firebase/firebase-ios-sdk.git) of the Package file.
3. Select the **firebase-ios-sdk** package product, select dependency rule and select Add Package.
4. Choose the Firebase products: **FirebaseAuth**, **FirebaseDatabase**, **FirebaseStorage** and press Add Package button again.

## Design
<img width="1017" alt="Screenshot 2023-01-04 at 4 27 36 PM" src="https://user-images.githubusercontent.com/70813562/210565294-c0bf0cc0-54cb-4413-9c2a-664a2b2ff893.png">

## Usage
### User registration
![Simulator Screen Recording - iPhone 12 mini (iOS 15 2) - 2023-01-04 at 16 36 08](https://user-images.githubusercontent.com/70813562/210566939-b7cf103a-1e87-480e-b06d-18e60c34bb3c.gif)

### Sending messages
![Simulator Screen Recording - iPhone 12 mini (iOS 15 2) - 2023-01-04 at 19 13 45](https://user-images.githubusercontent.com/70813562/210599755-e5f1c01e-51dc-401c-b3a5-5460be38c15c.gif)

### Adding class to schedule
![Simulator Screen Recording - iPhone 12 mini (iOS 15 2) - 2023-01-04 at 19 20 10](https://user-images.githubusercontent.com/70813562/210601107-15a5a6ee-bfec-400a-8b1a-4656ce3b1b04.gif)
