//
//  DailyCompletion.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import Foundation
import SwiftData

/// Records a single habit completion for a specific day.
/// `effectivePoints` captures the signed point value at the time of completion
/// so streak calculation stays accurate even if the habit is later edited or deleted.
@Model
class DailyCompletion {
    var date: Date          // normalized to start-of-day
    var habitId: UUID
    var effectivePoints: Int

    init(habit: Habit, date: Date = Date()) {
        self.habitId = habit.id
        self.effectivePoints = habit.points * (habit.type == .negative ? -1 : 1)
        self.date = Calendar.current.startOfDay(for: date)
    }
}
