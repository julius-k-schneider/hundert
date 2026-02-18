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
        resetIfNewDay()
        loadTodayCompletions()
    }

    // MARK: - Habits

    private func loadHabits() {
        guard let context = modelContext else { return }
        habits = (try? context.fetch(FetchDescriptor<Habit>())) ?? []
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

    // MARK: - Daily completions

    func toggleHabit(_ id: UUID) {
        guard let context = modelContext else { return }
        if completedHabitIds.contains(id) {
            completedHabitIds.remove(id)
            deleteCompletion(for: id, in: context)
        } else {
            completedHabitIds.insert(id)
            if let habit = habits.first(where: { $0.id == id }) {
                let record = DailyCompletion(habit: habit)
                context.insert(record)
                try? context.save()
            }
        }
    }

    private func deleteCompletion(for habitId: UUID, in context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let descriptor = FetchDescriptor<DailyCompletion>(
            predicate: #Predicate { $0.habitId == habitId && $0.date >= today && $0.date < tomorrow }
        )
        if let record = try? context.fetch(descriptor).first {
            context.delete(record)
            try? context.save()
        }
    }

    private func loadTodayCompletions() {
        guard let context = modelContext else { return }
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let descriptor = FetchDescriptor<DailyCompletion>(
            predicate: #Predicate { $0.date >= today && $0.date < tomorrow }
        )
        let records = (try? context.fetch(descriptor)) ?? []
        completedHabitIds = Set(records.map { $0.habitId })
    }

    // MARK: - Daily reset

    private func resetIfNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        let defaults = UserDefaults.standard
        let lastDate = defaults.object(forKey: "lastActiveDate") as? Date
        if lastDate == nil || !Calendar.current.isDateInToday(lastDate!) {
            completedHabitIds = []
        }
        defaults.set(today, forKey: "lastActiveDate")
    }
}
