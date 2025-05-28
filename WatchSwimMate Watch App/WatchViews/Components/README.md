# SwimMate Watch App Components

This directory contains all reusable UI components for the SwimMate Watch App, organized by functionality.

## 📁 Directory Structure

### 🔘 Buttons/
Interactive button components for user actions.

- **`ActionButton.swift`** - Standard action button with haptic feedback and animations
- **`CompactNavButton.swift`** - Small circular navigation buttons for compact interfaces
- **`MainButton.swift`** - Primary navigation buttons with chevron indicators
- **`MainControlButton.swift`** - Large circular control buttons for main actions (2x2 grid layout)

### 🃏 Cards/
Card-based display components for presenting information.

- **`MetricCard.swift`** - Displays workout metrics (heart rate, calories, laps, pace) with responsive sizing
- **`PerformanceCard.swift`** - Shows performance data with trend indicators and includes `PerformanceMetricsSection`

### 📊 Display/
Information display components for showing data and status.

- **`ElapsedTimeView.swift`** - Displays elapsed workout time with custom formatter (shows subseconds < 1 hour)
- **`InsightRow.swift`** - Simple row layout for displaying insights with icon, title, and value
- **`IntensityIndicator.swift`** - Visual intensity indicator based on heart rate zones (1-5 bars)

### 🧭 Navigation/
Components for navigation and step-by-step guidance.

- **`NavigationControls.swift`** - Complete navigation control system with prev/next buttons and step indicator
- **`StepView.swift`** - Displays workout steps with encouragement text based on progress

### 🎉 Overlays/
Overlay components for special UI states.

- **`CelebrationOverlay.swift`** - Celebration overlay shown after workout completion

### 📈 Progress/
Progress tracking and visualization components.

- **`ProgressBar.swift`** - Animated progress bar for showing completion status

## 🎨 Design Patterns

### Responsive Design
Most components support compact/normal sizing modes:
- Use `isCompact: Bool` parameter for size variations
- Automatically adjust fonts, spacing, and dimensions
- Optimized for Apple Watch screen constraints

### Animation & Feedback
- Consistent spring animations for button interactions
- Haptic feedback integration (`WKInterfaceDevice.current().play()`)
- Scale and opacity effects for visual feedback

### Color & Theming
- Consistent color usage across components
- Support for system colors and custom tints
- Proper contrast and accessibility considerations

## 🔧 Usage Guidelines

### Import Structure
When using these components in your views, import from the appropriate subdirectory:

```swift
// Example usage in a view
import SwiftUI

struct MyWorkoutView: View {
    var body: some View {
        VStack {
            // Use components as needed
            MetricCard(title: "Heart Rate", value: "142", unit: "bpm", color: .red, icon: "heart.fill", isCompact: false)
            
            ActionButton(label: "Start", icon: "play.fill", tint: .green) {
                // Action
            }
        }
    }
}
```

### Best Practices
1. **Consistency**: Use the same component types for similar functionality
2. **Responsive**: Always consider compact mode for smaller screens
3. **Accessibility**: Ensure proper contrast and text sizing
4. **Performance**: Leverage SwiftUI's built-in optimizations

## 📱 Component Dependencies

### External Dependencies
- `SwiftUI` - All components
- `WatchKit` - For haptic feedback in buttons

### Internal Dependencies
- `WatchManager` - Used by `PerformanceCard` for workout data
- Components are designed to be as independent as possible

## 🚀 Future Enhancements

Consider these areas for future component development:
- **Charts/** - Data visualization components
- **Forms/** - Input and form components
- **Animations/** - Reusable animation components
- **Accessibility/** - Enhanced accessibility components

---

*Last updated: May 2025*
*SwimMate v1.0* 