//
//  ContentView.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var store = HabitStore()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            TodayView(store: store)
                .tabItem {
                    Label("Today", systemImage: "sun.max")
                }

            HistoryView(store: store)
                .tabItem {
                    Label("History", systemImage: "calendar")
                }

            SettingsView(store: store)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onAppear { store.configure(with: modelContext) }
    }
}

// ---------------------------------------------------------
// PLATZHALTER FÜR DEINE KOMPONENTEN
// (Damit der Code kopiert & ausgeführt werden kann)
// ---------------------------------------------------------


struct SoftPulse: ViewModifier {
    @State private var anim = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .scaleEffect(anim && !reduceMotion ? 1.03 : 1.0)
            .opacity(anim && !reduceMotion ? 1.0 : 0.85)
            .animation(
                reduceMotion ? nil : .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                value: anim
            )
            .onAppear { anim = true }
    }
}

extension View {
    func softPulse() -> some View { modifier(SoftPulse()) }
}

struct HabitCard: View {
    let habit: Habit
    let isCompleted: Bool
    let onToggle: () -> Void
    let onRemove: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray)
            }
            .accessibilityLabel(isCompleted ? "Mark \(habit.title) incomplete" : "Mark \(habit.title) complete")

            VStack(alignment: .leading) {
                Text(habit.title)
                    .fontWeight(.medium)
                    .strikethrough(isCompleted)
                    .foregroundColor(isCompleted ? .secondary : .primary)
                Text("\(habit.points) pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: { showDeleteConfirmation = true }) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.7))
            }
            .accessibilityLabel("Delete \(habit.title)")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .confirmationDialog("Delete \"\(habit.title)\"?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: onRemove)
            Button("Cancel", role: .cancel) {}
        }
    }
}

// Preview für Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

