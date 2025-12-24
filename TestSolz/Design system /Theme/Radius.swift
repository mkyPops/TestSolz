//
//  Radius.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Border Radius System
// Consistent corner radius values for cards, buttons, inputs
// Keeps the UI cohesive and professional

struct Radius {
    
    // MARK: - Base Radius Scale
    static let none: CGFloat = 0        // Sharp corners (rarely used)
    static let xs: CGFloat = 4          // Subtle rounding (badges, tags)
    static let sm: CGFloat = 8          // Small rounding (buttons, inputs)
    static let md: CGFloat = 12         // Medium rounding (cards, modals) - MOST COMMON
    static let lg: CGFloat = 16         // Large rounding (prominent cards)
    static let xl: CGFloat = 20         // Extra large (hero cards)
    static let xxl: CGFloat = 24        // Double extra large (special elements)
    static let full: CGFloat = 999      // Fully rounded (pills, circular buttons)
    
    // MARK: - Semantic Radius (named by component)
    static let button: CGFloat = sm              // 8px - standard button
    static let buttonLarge: CGFloat = md         // 12px - large CTA buttons
    static let buttonPill: CGFloat = full        // Fully rounded pill buttons
    
    static let card: CGFloat = md                // 12px - standard cards
    static let cardLarge: CGFloat = lg           // 16px - prominent cards
    
    static let input: CGFloat = sm               // 8px - text fields
    static let badge: CGFloat = xs               // 4px - small badges
    static let modal: CGFloat = lg               // 16px - modals, sheets
    
    static let avatar: CGFloat = full            // Circular avatars
    static let avatarSquare: CGFloat = sm        // Rounded square avatars
}

// MARK: - Corner Radius Modifier Extension
// Convenience extension for applying corner radius
// Usage: .cornerRadius(.md) instead of .cornerRadius(Radius.md)

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Rounded Corner Shape (for specific corners)
// Allows rounding only specific corners (top-left, bottom-right, etc.)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
