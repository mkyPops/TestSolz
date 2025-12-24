//
//  AppTheme.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - App Theme
// Central theme configuration that brings together all design tokens
// Colors, Typography, Spacing, Radius, and Shadows in one place

struct AppTheme {
    
    // MARK: - Quick Access to Design Tokens
    static let colors = ColorPalette.self
    static let typography = AppTypography.self
    static let spacing = Spacing.self
    static let radius = Radius.self
    static let shadows = Shadows.self
    
    // MARK: - Theme Configuration
    struct Configuration {
        // Animation durations
        static let animationFast: Double = 0.2
        static let animationNormal: Double = 0.3
        static let animationSlow: Double = 0.5
        
        // Haptic feedback
        static let enableHaptics: Bool = true
        
        // Interactive element sizes
        static let minTapTarget: CGFloat = 44  // Apple's minimum touch target
        static let iconSizeSmall: CGFloat = 16
        static let iconSizeMedium: CGFloat = 24
        static let iconSizeLarge: CGFloat = 32
        
        // Screen padding
        static let screenPadding = EdgeInsets(
            top: Spacing.screenVertical,
            leading: Spacing.screenHorizontal,
            bottom: Spacing.screenVertical,
            trailing: Spacing.screenHorizontal
        )
    }
}

// MARK: - Common View Modifiers
// Pre-built modifiers for common styling patterns

extension View {
    
    // MARK: - Screen Container
    // Standard screen layout with padding and background
    func screenContainer(background: Color = ColorPalette.background) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background.ignoresSafeArea())
            .padding(AppTheme.Configuration.screenPadding)
    }
    
    // MARK: - Card Container
    // Standard card styling
    func card(
        padding: CGFloat = Spacing.cardPadding,
        background: Color = ColorPalette.cardBackground,
        radius: CGFloat = Radius.card,
        shadow: ShadowStyle = Shadows.card
    ) -> some View {
        self
            .padding(padding)
            .background(background)
            .cornerRadius(radius)
            .shadow(shadow)
    }
    
    // MARK: - Primary Button Style
    func primaryButtonStyle() -> some View {
        self
            .font(AppTypography.buttonMedium)
            .foregroundColor(ColorPalette.textOnPrimary)
            .padding(.horizontal, Spacing.buttonPaddingHorizontal)
            .padding(.vertical, Spacing.buttonPaddingVertical)
            .background(ColorPalette.primary)
            .cornerRadius(Radius.button)
            .shadow(Shadows.button)
    }
    
    // MARK: - Secondary Button Style
    func secondaryButtonStyle() -> some View {
        self
            .font(AppTypography.buttonMedium)
            .foregroundColor(ColorPalette.textPrimary)
            .padding(.horizontal, Spacing.buttonPaddingHorizontal)
            .padding(.vertical, Spacing.buttonPaddingVertical)
            .background(ColorPalette.buttonSecondary)
            .cornerRadius(Radius.button)
    }
    
    // MARK: - Input Field Style
    func inputFieldStyle() -> some View {
        self
            .font(AppTypography.bodyMedium)
            .padding(.horizontal, Spacing.inputPaddingHorizontal)
            .padding(.vertical, Spacing.inputPaddingVertical)
            .background(ColorPalette.backgroundSecondary)
            .cornerRadius(Radius.input)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.input)
                    .stroke(ColorPalette.border, lineWidth: 1)
            )
    }
    
    // MARK: - Section Header Style
    func sectionHeader() -> some View {
        self
            .font(AppTypography.labelMedium)
            .foregroundColor(ColorPalette.textSecondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

// MARK: - Animation Helpers
extension Animation {
    static var fast: Animation {
        .easeInOut(duration: AppTheme.Configuration.animationFast)
    }
    
    static var normal: Animation {
        .easeInOut(duration: AppTheme.Configuration.animationNormal)
    }
    
    static var slow: Animation {
        .easeInOut(duration: AppTheme.Configuration.animationSlow)
    }
}

// MARK: - Haptic Feedback Helper
struct HapticManager {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard AppTheme.Configuration.enableHaptics else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard AppTheme.Configuration.enableHaptics else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    static func selection() {
        guard AppTheme.Configuration.enableHaptics else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
