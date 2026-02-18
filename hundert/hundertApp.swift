//
//  hundertApp.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI
import SwiftData

@main
struct hundertApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Habit.self, DailyCompletion.self])
    }
}
