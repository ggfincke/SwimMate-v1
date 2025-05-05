# 🏊‍♂️ SwimMate

SwimMate is a comprehensive swimming workout tracker designed for iOS and watchOS. It helps swimmers track their pool and open water workouts, follow structured swim sets, set workout goals, and analyze their swimming performance over time.

## ✨ Features

### 📱 iOS App Features
- **Workout History**: View and analyze your past swimming workouts.
- **Swim Set Library**: Browse a collection of pre-defined swimming workouts with various difficulty levels and stroke types.
- **Workout Analytics**: View charts and statistics about your swimming performance, including:
  - Distance and pace trends
  - Calories burned
  - Swimming metrics over time
- **User Preferences**: Customize your experience with units (meters/yards) and preferred stroke settings.
- **Health Integration**: Fetches swim workout data from Apple HealthKit.

### ⌚ Apple Watch App Features
- **Workout Tracking**: Track pool and open water swims with real-time metrics.
- **Goal-Based Workouts**: Set goals for distance, time, or calories.
- **Swim Set Support**: Follow structured swim sets sent from the iOS app.
- **Real-Time Metrics**: View your current pace, heart rate, distance, laps, and calories.
- **Water Lock**: Enable water lock during swims for touch protection.

## 🛠️ Technical Details

### 📱 iOS App
- **SwiftUI**: Built entirely with SwiftUI for a modern, responsive interface.
- **HealthKit**: Integrates with Apple HealthKit to read and store swimming workout data.
- **WatchConnectivity**: Communicates with the Apple Watch app to send swim sets.
- **Swift Charts**: Visualizes swimming data with interactive charts.
- **Data Storage**: Uses local JSON storage for user preferences and cached workout data.

### ⌚ Apple Watch App
- **SwiftUI**: Optimized UI for the Apple Watch screen.
- **HealthKit**: Records swimming workouts and metrics in real-time.
- **WatchConnectivity**: Receives structured swim sets from the iOS app.
- **WKInterfaceDevice**: Manages watch-specific features like water lock.
- **SwiftUI Navigation**: Uses a path-based navigation system with TabView for workout controls.

### 🏊‍♂️ Swim Workout Types
- **Pool Swimming**: Configurable with pool length and unit selection.
- **Open Water Swimming**: GPS tracking for distance in open water.

### 📊 Swimming Metrics
- Swim distance
- Duration
- Laps completed
- Calories burned
- Heart rate
- Pace per 100m or 100yd
- SWOLF score (Swimming efficiency metric)
- Stroke style tracking

### 📝 Swim Set Features
- **Structured Workouts**: Follows a sequence of swimming instructions.
- **Multiple Stroke Types**: Freestyle, backstroke, breaststroke, butterfly, and individual medley (IM).
- **Difficulty Levels**: Beginner, intermediate, and advanced sets.
- **Unit Support**: Both meters and yards.

## 📋 Requirements
- iOS 17.4+
- watchOS 10.4+
- iPhone with paired Apple Watch
- Apple Health permission for workout and heart rate data

## 🚀 Future Enhancements
- Workout segments for interval training
- Custom swim set creation
- Cloud synchronization for workout data
- Social sharing features
- Additional analytics and goal tracking

## 🔒 Privacy
SwimMate uses HealthKit data only with user permission. Your swimming workout data is stored locally on your device and is never shared with third parties without your explicit consent.

## 👏 Credits
Created by Garrett Fincke, this app was originally developed as a final project for CMPSC475 (Applications Programming) at PSU, and later evolved into a personal project to explore Swift/HealthKit and help swimmers track and improve their performance in the pool and open water.
