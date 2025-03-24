# 🍽️ Restaurant Finder - SwiftUI App

This is a SwiftUI application that displays a list of restaurants with filtering based on **user location** and **search input**.  
The app prompts the user for location access and, if granted, lists **nearby restaurants** within a **3KM radius**.  
If location access is denied, the app lists **all restaurants**.

## ✨ Features
- **Location-based filtering**: Displays only nearby restaurants when access is granted.
- **Search functionality**: Allows users to search for restaurants by name or description.
- **MVVM Architecture**: The code is structured with a clean **ViewModel** that separates logic from the UI.
- **Mock Data**: Predefined restaurant data with images, names, descriptions, and geolocation.

## 🏗️ Project Structure
- **Models**: Defines the `Restaurant` struct with properties like name, description, image, and geolocation.
- **ViewModel (`RestaurantViewModel`)**:  
  - Manages location authorization using `CLLocationManager`.  
  - Filters restaurants based on user location and search input.
- **Views**:
  - `RestaurantListView`: Main UI with a **search bar** and restaurant list.
  - `RestaurantRow`: Displays individual restaurant details.
  
## 🛠️ How It Works
1. On app launch, the app asks for **location permission**.
2. If the user **grants access**, it lists **restaurants within 3KM**.
3. If the user **denies access**, it lists **all restaurants**.
4. The **search bar** filters restaurants based on name or description.

