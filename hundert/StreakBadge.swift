//
//  StreakBadge.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI

struct StreakBadge: View {
    let streak: Int
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .foregroundColor(.orange)
            Text("\(streak) days")
                .font(.footnote)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.orange.opacity(0.15))
        .clipShape(Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(streak) day streak")
    }
}

#Preview {
    VStack(spacing: 20) {
        StreakBadge(streak: 0) // Inaktiv
        StreakBadge(streak: 3) // Aktiv
        StreakBadge(streak: 10) // On Fire!
    }
    .padding()
}
