//
//  HabitStore.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI

@Observable
class HabitStore {

    var habits: [Habit] = [
        Habit(title: "Wasser trinken", points: 20, emoji: "💧", type: .positive),
        Habit(title: "Lesen", points: 30, emoji: "📚", type: .positive)
    ]
    var currentStreak: Int = 5
    var completedHabitIds: Set<UUID> = []

    var todayPoints: Int {
        habits.reduce(0) { sum, habit in
            guard completedHabitIds.contains(habit.id) else { return sum }
            let delta = habit.points * (habit.type == .negative ? -1 : 1)
            return sum + delta
        }
    }

    func toggleHabit(_ id: UUID) {
        if completedHabitIds.contains(id) {
            completedHabitIds.remove(id)
        } else {
            completedHabitIds.insert(id)
        }
    }

    func addNewHabit(title: String, points: Int, emoji: String, type: HabitType) {
        let newHabit = Habit(title: title, points: points, emoji: emoji, type: type)
        habits.append(newHabit)
    }

    func removeHabit(_ id: UUID) {
        habits.removeAll { $0.id == id }
        completedHabitIds.remove(id)
    }

    func isHabitCompleted(_ id: UUID) -> Bool {
        return completedHabitIds.contains(id)
    }
}
