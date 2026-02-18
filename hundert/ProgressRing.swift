//
//  ProgressRing.swift
//  hundert
//
//  Created by Julius on 07.01.26.
//

import SwiftUI
import UIKit

struct ProgressRing: View {
    // Props aus deinem React-Code
    var points: Int
    var goal: Int = 100
    var size: CGFloat = 200
    var strokeWidth: CGFloat = 12
    
    // State für die Animation
    @State private var animatedProgress: CGFloat = 0
    @State private var showSuccessEffects: Bool = false
    
    // Berechnete Eigenschaften
    private var progress: CGFloat {
        min(CGFloat(points) / CGFloat(goal), 1.0)
    }
    
    private var isComplete: Bool {
        points >= goal
    }
    
    // Farben (Angelehnt an deine CSS Variablen)
    // Du kannst diese durch deine Asset-Catalog Farben ersetzen
    private var gradientColors: [Color] {
        [Color.green, Color.orange, Color.red] // Primary -> Accent
    }
    
    private var successColor: Color {
        Color.green // Success
    }
    
    var body: some View {
        ZStack {
            // 1. Hintergrund-Kreis (Muted)
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: strokeWidth)
            
            // 2. Fortschritts-Kreis
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    // Wenn fertig: Grün, sonst: Gradient
                    isComplete ? AnyShapeStyle(successColor) : AnyShapeStyle(LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )),
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start bei 12 Uhr
                // Glow Effekt (Shadow), wenn fertig
                .shadow(color: isComplete ? successColor.opacity(0.6) : .clear, radius: isComplete ? 10 : 0)
                .animation(.easeOut(duration: 1.0), value: animatedProgress)
            
            // 3. Text Inhalt in der Mitte
            VStack(spacing: 4) {
                Text("\(Int(animatedProgress * CGFloat(goal)))") // Animierter Zähler
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(isComplete ? successColor : .primary)
                    // Zahlen-Übergangseffekt (iOS 16+)
                    .contentTransition(.numericText(value: Double(points)))
                
                Text("/ \(goal) pts")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if showSuccessEffects {
                    Text("🎉 Goal reached!")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(successColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(points) of \(goal) points\(isComplete ? ", goal reached" : "")")
        .accessibilityValue("\(Int(progress * 100)) percent")
        .onAppear {
            // Verzögerte Animation beim Laden (wie dein useEffect)
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = progress
            }
            
            if isComplete {
                // Success Text etwas verzögert einblenden
                withAnimation(.bouncy.delay(0.5)) {
                    showSuccessEffects = true
                }
            }
        }
        // Reagiert auf Änderungen der Punkte von außen
        .onChange(of: points) { oldValue, newValue in
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = min(CGFloat(newValue) / CGFloat(goal), 1.0)
                showSuccessEffects = newValue >= goal
            }
            if newValue >= goal, oldValue < goal {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
    }
}

// Vorschau für Canvas
#Preview {
    VStack(spacing: 50) {
        ProgressRing(points: 70, goal: 100)
        ProgressRing(points: 100, goal: 100)
    }
}
