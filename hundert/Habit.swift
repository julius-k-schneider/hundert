//
//  Habit.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import Foundation

enum HabitType: String, Codable {
    case positive
    case negative
}
struct Habit: Identifiable, Codable {
    let id: UUID
    var title: String
    var points: Int
    var emoji: String
    var type: HabitType

    init(id: UUID = UUID(), title: String, points: Int, emoji: String = "🎯", type: HabitType = .positive) {
        self.id = id
        self.title = title
        self.points = points
        self.emoji = emoji
        self.type = type
    }
}

