//
//  HistoryView.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI

struct HistoryView: View {
    @Bindable var store: HabitStore

    var body: some View {
        NavigationStack {
            Group {
                let history = store.fetchHistory()
                if history.isEmpty {
                    ContentUnavailableView(
                        "No History Yet",
                        systemImage: "calendar.badge.clock",
                        description: Text("Complete habits to start building your history.")
                    )
                } else {
                    List(history, id: \.date) { entry in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.date, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                                    .font(.headline)
                                Text("\(entry.points) pts")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: entry.goalMet ? "checkmark.circle.fill" : "xmark.circle")
                                .font(.title2)
                                .foregroundColor(entry.goalMet ? .green : .secondary)
                                .accessibilityLabel(entry.goalMet ? "Goal met" : "Goal not met")
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}
