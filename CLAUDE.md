# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is an Xcode iOS project. Open `hundert.xcodeproj` in Xcode and run on a simulator or device. There are no external dependencies or package managers.

To build from the command line:
```bash
xcodebuild -project hundert.xcodeproj -scheme hundert -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Architecture

**hundert** is a SwiftUI iOS habit tracker where the daily goal is to accumulate 100 points by completing habits.

### State Management

`HabitStore` (`HabitStore.swift`) is the single source of truth — an `@MainActor ObservableObject` held as `@StateObject` in `ContentView`. All habit mutations go through it. There is currently **no persistence**: habits reset on app launch and `currentStreak` is hardcoded to `5`.

### Data Model

`Habit` (`Habit.swift`) is a `Codable/Identifiable` struct with a `HabitType` enum (`.positive` adds points, `.negative` subtracts points). Points are capped by convention at 1–50 in the UI.

### View Hierarchy

- `ContentView` — root view; owns `HabitStore`; contains `ProgressRing`, `HabitCard` list, summary stats, and `AddHabitView`
- `ProgressRing` — animated circular progress toward the 100-point goal; triggers haptic feedback on goal completion
- `AddHabitView` / `AddHabitFormContent` — bottom button + modal sheet for creating habits (type, emoji, name, points)
- `StreakBadge` — header chip displaying current streak
- `HabitCard` and `SoftPulse` view modifier are defined inline in `ContentView.swift`

### Known Issues / Quirks

- `AddHabbitView.swift` has a typo in the **filename** (double "b"), but the struct inside is correctly named `AddHabitView`.
- `completedHabitIds` tracks today's completions in memory only; there is no date-aware reset logic yet.
