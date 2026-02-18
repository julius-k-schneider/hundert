//
//  Habit.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import Foundation
import SwiftData

enum HabitType: String, Codable {
    case positive
    case negative
}

@Model
class Habit {
    var id: UUID
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
