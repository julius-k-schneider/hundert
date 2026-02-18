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

    var goalReached: Bool {
        store.todayPoints >= 100
    }

    var body: some View {
        ZStack {
            // Background Color (bg-background)
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                // sticky top-0 -> Wir setzen es einfach ganz oben in den VStack (außerhalb vom ScrollView)
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "target") // Lucide Target Icon
                            .font(.system(size: 24))
                            .foregroundColor(Color.orange) // text-primary
                        
                        Text("hundert")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    StreakBadge(streak: store.currentStreak)
                }
                .padding()
                .background(.ultraThinMaterial) // backdrop-blur-lg
                .overlay(alignment: .bottom) {
                    Divider()
                } // border-b

                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 32) { // py-8 und Abstand zwischen Sektionen
                        
                        // MARK: Progress Section
                        VStack(spacing: 16) {
                            Text("Today's Progress")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary) // text-muted-foreground
                            
                            ProgressRing(points: store.todayPoints)
                            
                            if goalReached {
                                Text("Amazing work! Keep the streak going! 🔥")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green) // text-success
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
                                // Empty State
                                VStack(spacing: 8) {
                                    Text("No habits yet")
                                        .foregroundColor(.secondary)
                                    Text("Add your first habit to start tracking!")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 48)
                                .frame(maxWidth: .infinity)
                                .background(Color(.secondarySystemBackground)) // bg-muted/50
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5])) // border-dashed
                                        .foregroundColor(Color(.separator))
                                )
                            } else {
                                // Habits List
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
                        .background(Color(.secondarySystemBackground)) // bg-card
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                        
                    }
                    .padding(.horizontal) // container px-4
                    .padding(.bottom, 40)
                }
                
                Spacer() // Drückt den Button nach unten, falls Platz ist
                                
                AddHabitView { name, points, emoji, type in
                    // Hier fügen wir das neue Habit dem Store hinzu
                    store.addNewHabit(title: name, points: points, emoji: emoji, type: type)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

// ---------------------------------------------------------
// PLATZHALTER FÜR DEINE KOMPONENTEN
// (Damit der Code kopiert & ausgeführt werden kann)
// ---------------------------------------------------------


struct SoftPulse: ViewModifier {
    @State private var anim = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(anim ? 1.03 : 1.0)
            .opacity(anim ? 1.0 : 0.85)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: anim)
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
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
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

