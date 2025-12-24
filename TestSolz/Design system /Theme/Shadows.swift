//
//  Shadows.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Shadow System
// Consistent elevation/shadow styles for depth perception
// Minimal, professional shadows that add depth without being heavy

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    init(color: Color = ColorPalette.cardShadow, radius: CGFloat, x: CGFloat = 0, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

struct Shadows {
    
    // MARK: - Elevation Levels (Material Design inspired)
    // Subtle shadows for professional, minimal look
    
    static let none = ShadowStyle(
        color: .clear,
        radius: 0,
        y: 0
    )
    
    // Level 1: Barely visible (hover states, subtle elevation)
    static let xs = ShadowStyle(
        color: Color.black.opacity(0.02),
        radius: 2,
        y: 1
    )
    
    // Level 2: Subtle (cards at rest, default elevation)
    static let sm = ShadowStyle(
        color: Color.black.opacity(0.04),
        radius: 4,
        y: 2
    )
    
    // Level 3: Moderate (raised cards, buttons)
    static let md = ShadowStyle(
        color: Color.black.opacity(0.06),
        radius: 8,
        y: 4
    )
    
    // Level 4: Elevated (dropdowns, popovers)
    static let lg = ShadowStyle(
        color: Color.black.opacity(0.08),
        radius: 12,
        y: 6
    )
    
    // Level 5: Floating (modals, dialogs)
    static let xl = ShadowStyle(
        color: Color.black.opacity(0.10),
        radius: 16,
        y: 8
    )
    
    // Level 6: Maximum elevation (full-screen overlays)
    static let xxl = ShadowStyle(
        color: Color.black.opacity(0.12),
        radius: 24,
        y: 12
    )
    
    // MARK: - Semantic Shadows (named by purpose)
    static let card = sm                  // Default card shadow
    static let cardHover = md             // Card on hover/press
    static let button = xs                // Subtle button shadow
    static let buttonPressed = none       // No shadow when pressed
    static let modal = xl                 // Modal/sheet shadow
    static let dropdown = lg              // Dropdown menu shadow
}

// MARK: - Shadow Modifier Extension
// Convenience extension for applying shadows
// Usage: .shadow(.card) instead of .shadow(color: ..., radius: ..., x: ..., y: ...)

extension View {
    func shadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
}

// MARK: - Card Style Modifier
// Complete card styling with background, radius, and shadow
// Usage: .cardStyle() for instant professional card appearance

extension View {
    func cardStyle(
        backgroundColor: Color = ColorPalette.cardBackground,
        cornerRadius: CGFloat = Radius.card,
        shadow: ShadowStyle = Shadows.card
    ) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(shadow)
    }
}
