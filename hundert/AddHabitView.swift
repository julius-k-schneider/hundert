//
//  AddHabbitView.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI

struct AddHabitView: View {
    // Callback Closure (wie in React props.onAdd)
    var onAdd: (String, Int, String, HabitType) -> Void
    
    // State für das Modal
    @State private var showModal = false
    
    var body: some View {
        Button(action: {
            showModal = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add Habit")
            }
            .font(.headline)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .foregroundColor(.white) // text-primary-foreground
            .background(Color.accentColor) // bg-primary
            .clipShape(RoundedRectangle(cornerRadius: 12)) // rounded-xl
            .shadow(color: Color.accentColor.opacity(0.5), radius: 8, x: 0, y: 4) // shadow-glow
        }
        .sheet(isPresented: $showModal) {
            // Hier öffnen wir das eigentliche Formular
            AddHabitFormContent(showModal: $showModal, onAdd: onAdd)
                .presentationDetents([.medium, .large]) // iOS 16+: Sheet Größe
                .presentationDragIndicator(.visible)
        }
    }
}

// Die interne Formular-View (das Äquivalent zum DialogContent)
struct AddHabitFormContent: View {
    @Binding var showModal: Bool
    var onAdd: (String, Int, String, HabitType) -> Void
    
    // Formular State
    @State private var name: String = ""
    @State private var points: Int = 20
    @State private var emoji: String = "🎯"
    @State private var type: HabitType = .positive
    
    // Konstanten
    let positiveEmojis = ["🏃", "📚", "💧", "🧘", "📵", "✍️", "🥗", "😴", "🎯", "💪", "🧠", "🌱"]
    let negativeEmojis = ["🍺", "🍔", "📱", "🎮", "🚬", "🍭", "☕", "🛋️", "💸", "😤", "🌙", "🍕"]
    let quickPoints = [10, 20, 25, 30]
    
    var currentEmojis: [String] {
        type == .positive ? positiveEmojis : negativeEmojis
    }
    
    // Berechnete Farben basierend auf Typ
    var themeColor: Color {
        type == .positive ? .green : .red
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 1. TYPE SELECTOR
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            TypeButton(
                                title: "✓ Habit",
                                isSelected: type == .positive,
                                color: .green
                            ) {
                                type = .positive
                                emoji = "🎯"
                            }
                            
                            TypeButton(
                                title: "✗ Laster",
                                isSelected: type == .negative,
                                color: .red
                            ) {
                                type = .negative
                                emoji = "🍺"
                            }
                        }
                    }
                    
                    // 2. EMOJI PICKER
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose an emoji")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                            ForEach(currentEmojis, id: \.self) { e in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        emoji = e
                                    }
                                }) {
                                    Text(e)
                                        .font(.title2)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(emoji == e ? themeColor.opacity(0.2) : Color(uiColor: .secondarySystemBackground))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(emoji == e ? themeColor : Color.clear, lineWidth: 2)
                                        )
                                        .scaleEffect(emoji == e ? 1.1 : 1.0)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(e)
                                .accessibilityAddTraits(emoji == e ? .isSelected : [])
                            }
                        }
                    }
                    
                    // 3. NAME INPUT
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habit name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("e.g., Morning run", text: $name)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // 4. POINTS INPUT
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Points (1-50)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            TextField("", value: $points, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 80, height: 50)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            // Quick Select Buttons
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(quickPoints, id: \.self) { p in
                                        Button(action: { points = p }) {
                                            Text("\(p)")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(
                                                    points == p ? Color.accentColor : Color(uiColor: .secondarySystemBackground)
                                                )
                                                .foregroundColor(points == p ? .white : .primary)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                        .accessibilityLabel("\(p) points")
                                        .accessibilityAddTraits(points == p ? .isSelected : [])
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    // SUBMIT BUTTON
                    Button(action: submit) {
                        Text("Add Habit")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(name.isEmpty ? Color.gray.opacity(0.3) : Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(name.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Create New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showModal = false }
                }
            }
        }
    }
    
    // Logik beim Absenden
    private func submit() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // Callback aufrufen
        onAdd(name, points, emoji, type)
        
        // Reset State (optional, da View neu erstellt wird, aber sauberer)
        name = ""
        points = 20
        showModal = false
    }
}

// Hilfs-View für die Typ-Buttons
struct TypeButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? color.opacity(0.2) : Color(uiColor: .secondarySystemBackground))
                .foregroundColor(isSelected ? color : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                )
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// Preview
#Preview {
    AddHabitView { name, points, emoji, type in
        print("New Habit: \(emoji) \(name) - \(points) pts (\(type))")
    }
    .padding()
}

