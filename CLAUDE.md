# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SwimMate is a comprehensive swimming workout tracker built for iOS and watchOS using SwiftUI. The app consists of two main targets:
- **SwimMate (iOS)**: Main app for workout history, analytics, and swim set library
- **WatchSwimMate Watch App**: Apple Watch companion for real-time workout tracking

## Build Commands

This is an Xcode project (`.xcodeproj`). Use Xcode's built-in build system:
- **Build**: Use Xcode's Product → Build (⌘B) or build via Xcode's interface
- **Run on Simulator**: Select simulator and run via Xcode
- **Run on Device**: Connect device and run via Xcode
- **Archive**: Product → Archive for App Store distribution

No separate package managers (CocoaPods/SPM packages) are used - this is a pure Xcode project.

## Architecture Overview

### Core Data Models
Located in `SwimMate/Model/`:
- **Workout Models** (`Workout/`): `Swim`, `Lap`, `LapGroup` - represent completed workouts
- **Set Models** (`Sets/`): `SwimSet`, `SetComponent` - structured workout templates
- **Type Models** (`Types/`): `SwimStroke`, `MeasureUnit`, `SwimmingLocationType` - enums and types

### State Management
- **Manager.swift**: Main iOS view model with HealthKit integration, user preferences, and workout data
- **WatchManager.swift**: Watch-specific state management for real-time workout tracking
- **WatchConnector.swift**: Handles communication between iOS and watchOS apps

### View Architecture
**iOS Views** (`SwimMate/iOSViews/`):
- `RootView/`: Main navigation and app entry point
- `HomeView/`: Dashboard with recent activity and metrics
- `SwimViews/`: Workout-related views (logbook, sets, workout details)
- `SettingsView/`: User preferences and health permissions
- `Components/`: Reusable UI components (cards, charts, display elements)

**Watch Views** (`WatchSwimMate Watch App/WatchViews/`):
- `WatchRootView/`: Watch app navigation entry point
- `SwimSetup/`: Workout configuration and goal setting
- `SwimViews/`: Active workout tracking and metrics display
- `Components/`: Reusable watch-optimized UI components (see `Components/README.md`)

### Data Flow
1. **iOS App**: Manages workout history via HealthKit, provides swim set library
2. **Watch Connectivity**: Sends swim sets from iOS to Watch via `WatchConnector`
3. **Watch App**: Tracks real-time workouts, saves to HealthKit, syncs back to iOS
4. **HealthKit Integration**: Central data store for all workout data

### Key Features
- **HealthKit Integration**: Reads/writes swimming workout data
- **Real-time Metrics**: Heart rate, pace, distance, calories during workouts
- **Structured Swim Sets**: Pre-defined workouts with components (warmup, main set, cooldown)
- **Cross-platform Sync**: iOS-Watch communication for seamless experience
- **Goal Tracking**: Distance, time, and calorie-based workout goals

## Development Notes

### Shared Code
Data models in `SwimMate/Model/` are shared between iOS and watchOS targets through the Xcode project configuration.

### State Management Pattern
Both apps use `@StateObject` and `@EnvironmentObject` for SwiftUI state management:
- iOS: `Manager` as main view model
- Watch: `WatchManager` for workout tracking
- Connectivity: `WatchConnector` for iOS-Watch communication

### Navigation
- **iOS**: Uses SwiftUI's NavigationStack with programmatic navigation
- **Watch**: Uses TabView and NavigationStack optimized for watch interface

### Health Permissions
Both apps require HealthKit permissions for workout data. Permission handling is implemented in respective `HealthKitPermissionView` components.