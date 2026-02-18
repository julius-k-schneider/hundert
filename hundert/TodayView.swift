//
//  TodayView.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI

struct TodayView: View {
    @Bindable var store: HabitStore

    var goalReached: Bool {
        store.todayPoints >= 100
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "target")
                            .font(.system(size: 24))
                            .foregroundColor(Color.orange)

                        Text("hundert")
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    Spacer()

                    StreakBadge(streak: store.currentStreak)
                }
                .padding()
                .background(.ultraThinMaterial)
                .overlay(alignment: .bottom) {
                    Divider()
                }

                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 32) {

                        // MARK: Progress Section
                        VStack(spacing: 16) {
                            Text("Today's Progress")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)

                            ProgressRing(points: store.todayPoints)

                            if goalReached {
                                Text("Amazing work! Keep the streak going! 🔥")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                    .softPulse()
                            }
                        }
                        .padding(.top, 20)

                        // MARK: Habits Section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Your Habits")
                                    .font(.title3)
                                    .fontWeight(.bold)

                                Spacer()
                            }

                            if store.habits.isEmpty {
                                VStack(spacing: 8) {
                                    Text("No habits yet")
                                        .foregroundColor(.secondary)
                                    Text("Add your first habit in Settings!")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 48)
                                .frame(maxWidth: .infinity)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                        .foregroundColor(Color(.separator))
                                )
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(store.habits) { habit in
                                        HabitCard(
                                            habit: habit,
                                            isCompleted: store.isHabitCompleted(habit.id),
                                            onToggle: { store.toggleHabit(habit.id) },
                                            onRemove: { store.removeHabit(habit.id) }
                                        )
                                    }
                                }
                            }
                        }

                        // MARK: Summary Section
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total possible today")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)

                                let totalPoints = store.habits.reduce(into: 0) { partialResult, habit in
                                    partialResult += habit.points
                                }
                                Text("\(totalPoints) pts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("Remaining to goal")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)

                                Text("\(max(0, 100 - store.todayPoints)) pts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(24)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.separator), lineWidth: 1)
                        )

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
