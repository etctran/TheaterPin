//
//  AppTheme.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/30/25.
//

import SwiftUI

struct AppTheme {
    static let primaryRed = Color(red: 0.8, green: 0.2, blue: 0.3)
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.25)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.25)
    
    static let background = lightGray
    static let surface = Color.white
    static let primary = primaryRed
    static let secondary = darkBlue
    static let accent = gold
    static let textPrimary = darkGray
    static let textSecondary = Color.gray
    
    static let heroGradient = LinearGradient(
        colors: [darkBlue, primaryRed.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [surface, lightGray],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(AppTheme.primary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(AppTheme.primary)
            .padding()
            .background(AppTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.primary, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct MovieCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.surface)
            .cornerRadius(16)
            .shadow(color: AppTheme.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func movieCardStyle() -> some View {
        modifier(MovieCardStyle())
    }
}
