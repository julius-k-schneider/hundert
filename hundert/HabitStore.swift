//
//  HabitStore.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI
import SwiftData

@Observable
class HabitStore {

    var habits: [Habit] = []
    var currentStreak: Int = 5
    var completedHabitIds: Set<UUID> = []

    private var modelContext: ModelContext?

    func configure(with context: ModelContext) {
        guard modelContext == nil else { return }
        modelContext = context
        loadHabits()
    }

    private func loadHabits() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<Habit>()
        habits = (try? context.fetch(descriptor)) ?? []
        if habits.isEmpty {
            addNewHabit(title: "Wasser trinken", points: 20, emoji: "💧", type: .positive)
            addNewHabit(title: "Lesen", points: 30, emoji: "📚", type: .positive)
        }
    }

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
        guard let context = modelContext else { return }
        let habit = Habit(title: title, points: points, emoji: emoji, type: type)
        context.insert(habit)
        try? context.save()
        habits.append(habit)
    }

    func removeHabit(_ id: UUID) {
        guard let context = modelContext else { return }
        if let habit = habits.first(where: { $0.id == id }) {
            context.delete(habit)
            try? context.save()
            habits.removeAll { $0.id == id }
            completedHabitIds.remove(id)
        }
    }

    func isHabitCompleted(_ id: UUID) -> Bool {
        return completedHabitIds.contains(id)
    }
}
