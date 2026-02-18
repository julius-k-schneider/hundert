//
//  SettingsView.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var store: HabitStore

    var body: some View {
        NavigationStack {
            List {
                Section("Your Habits") {
                    if store.habits.isEmpty {
                        Text("No habits yet. Tap the button below to add one.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(store.habits) { habit in
                            HStack(spacing: 12) {
                                Text(habit.emoji)
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text(habit.title)
                                        .fontWeight(.medium)
                                    Text("\(habit.points) pts \(habit.type == .negative ? "(negative)" : "")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                store.removeHabit(store.habits[index].id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .safeAreaInset(edge: .bottom) {
                AddHabitView { name, points, emoji, type in
                    store.addNewHabit(title: name, points: points, emoji: emoji, type: type)
                }
                .padding(.bottom, 20)
            }
        }
    }
}
