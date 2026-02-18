# hundert

A SwiftUI iOS habit tracker where the daily goal is to accumulate **100 points** by completing habits.

## Features

- **Point-based tracking** -- create habits worth 1-50 points and complete them throughout the day to hit 100
- **Positive & negative habits** -- positive habits add points, negative habits subtract them
- **Streak tracking** -- counts consecutive days you've reached the 100-point goal
- **History view** -- review past daily completions
- **Persistence** -- habits and completions are stored with SwiftData

## Build & Run

Open `hundert.xcodeproj` in Xcode and run on a simulator or device. There are no external dependencies.

To build from the command line:

```bash
xcodebuild -project hundert.xcodeproj -scheme hundert \
  -destination 'platform=iOS Simulator,name=iPhone 16' build
```

**Requirements:** Xcode 15+ (SwiftUI, SwiftData)

## Project Structure

```
hundert/
├── hundertApp.swift        # App entry point; sets up SwiftData container
├── ContentView.swift       # Root TabView (Today / History / Settings)
├── TodayView.swift         # Daily habit list with progress ring
├── HistoryView.swift       # Past daily completion records
├── SettingsView.swift      # Manage and delete habits
├── Habit.swift             # Habit data model (@Model)
├── DailyCompletion.swift   # Daily completion record (@Model)
├── HabitStore.swift        # Central state management (@Observable)
├── ProgressRing.swift      # Animated circular progress toward 100 pts
├── StreakBadge.swift        # Streak counter badge
└── AddHabitView.swift      # Modal form for creating new habits
```

## Architecture

**HabitStore** is the single source of truth -- an `@Observable` class held as `@State` in `ContentView`. All mutations (toggling, adding, removing habits) go through it.

Data is persisted via **SwiftData** with two models: `Habit` (the habit definition) and `DailyCompletion` (a record of each completed habit on a given day). Completions store signed `effectivePoints` so history remains accurate even if a habit is later deleted.

Streaks are calculated by walking backward from today, counting consecutive days where total points reached 100.
