//
//  Typography.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Typography System
// Professional, readable, iOS-native typography
// Uses SF Pro (Apple's system font) for consistency and readability

struct AppTypography {
    
    // MARK: - Display Styles (Large headings, hero text)
    static let displayLarge = Font.system(size: 48, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 36, weight: .bold, design: .default)
    static let displaySmall = Font.system(size: 28, weight: .semibold, design: .default)
    
    // MARK: - Headline Styles (Screen titles, section headers)
    static let headlineLarge = Font.system(size: 24, weight: .bold, design: .default)
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .default)
    static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .default)
    
    // MARK: - Title Styles (Card titles, list headers)
    static let titleLarge = Font.system(size: 22, weight: .medium, design: .default)
    static let titleMedium = Font.system(size: 18, weight: .medium, design: .default)
    static let titleSmall = Font.system(size: 16, weight: .medium, design: .default)
    
    // MARK: - Body Styles (Main content text)
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
    
    // MARK: - Label Styles (Buttons, tabs, form labels)
    static let labelLarge = Font.system(size: 16, weight: .semibold, design: .default)
    static let labelMedium = Font.system(size: 14, weight: .semibold, design: .default)
    static let labelSmall = Font.system(size: 12, weight: .semibold, design: .default)
    
    // MARK: - Caption Styles (Timestamps, helper text, metadata)
    static let captionLarge = Font.system(size: 13, weight: .regular, design: .default)
    static let captionMedium = Font.system(size: 12, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)
    
    // MARK: - Button Styles
    static let buttonLarge = Font.system(size: 17, weight: .semibold, design: .default)
    static let buttonMedium = Font.system(size: 15, weight: .semibold, design: .default)
    static let buttonSmall = Font.system(size: 13, weight: .semibold, design: .default)
    
    // MARK: - Monospaced (for time, numbers, data)
    static let monoLarge = Font.system(size: 17, weight: .regular, design: .monospaced)
    static let monoMedium = Font.system(size: 15, weight: .regular, design: .monospaced)
    static let monoSmall = Font.system(size: 13, weight: .regular, design: .monospaced)
}

// MARK: - Text Style Modifiers
// Convenience modifiers for applying complete text styles
// Usage: Text("Hello").textStyle(.headlineLarge)

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(TextStyleModifier(style: style))
    }
}

struct TextStyleModifier: ViewModifier {
    let style: TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing)
    }
}

enum TextStyle {
    // Display
    case displayLarge
    case displayMedium
    case displaySmall
    
    // Headline
    case headlineLarge
    case headlineMedium
    case headlineSmall
    
    // Title
    case titleLarge
    case titleMedium
    case titleSmall
    
    // Body
    case bodyLarge
    case bodyMedium
    case bodySmall
    
    // Label
    case labelLarge
    case labelMedium
    case labelSmall
    
    // Caption
    case captionLarge
    case captionMedium
    case captionSmall
    
    // Button
    case buttonLarge
    case buttonMedium
    case buttonSmall
    
    var font: Font {
        switch self {
        // Display
        case .displayLarge: return AppTypography.displayLarge
        case .displayMedium: return AppTypography.displayMedium
        case .displaySmall: return AppTypography.displaySmall
            
        // Headline
        case .headlineLarge: return AppTypography.headlineLarge
        case .headlineMedium: return AppTypography.headlineMedium
        case .headlineSmall: return AppTypography.headlineSmall
            
        // Title
        case .titleLarge: return AppTypography.titleLarge
        case .titleMedium: return AppTypography.titleMedium
        case .titleSmall: return AppTypography.titleSmall
            
        // Body
        case .bodyLarge: return AppTypography.bodyLarge
        case .bodyMedium: return AppTypography.bodyMedium
        case .bodySmall: return AppTypography.bodySmall
            
        // Label
        case .labelLarge: return AppTypography.labelLarge
        case .labelMedium: return AppTypography.labelMedium
        case .labelSmall: return AppTypography.labelSmall
            
        // Caption
        case .captionLarge: return AppTypography.captionLarge
        case .captionMedium: return AppTypography.captionMedium
        case .captionSmall: return AppTypography.captionSmall
            
        // Button
        case .buttonLarge: return AppTypography.buttonLarge
        case .buttonMedium: return AppTypography.buttonMedium
        case .buttonSmall: return AppTypography.buttonSmall
        }
    }
    
    var color: Color {
        switch self {
        case .displayLarge, .displayMedium, .displaySmall,
             .headlineLarge, .headlineMedium, .headlineSmall,
             .titleLarge, .titleMedium, .titleSmall,
             .bodyLarge, .bodyMedium, .bodySmall,
             .labelLarge, .labelMedium, .labelSmall,
             .buttonLarge, .buttonMedium, .buttonSmall:
            return ColorPalette.textPrimary
            
        case .captionLarge, .captionMedium, .captionSmall:
            return ColorPalette.textSecondary
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .displayLarge, .displayMedium: return 4
        case .displaySmall, .headlineLarge: return 3
        case .headlineMedium, .headlineSmall: return 2
        case .titleLarge, .titleMedium, .titleSmall: return 1.5
        case .bodyLarge, .bodyMedium: return 4
        case .bodySmall: return 3
        default: return 1
        }
    }
}

// MARK: - Line Height Helper
// For custom line height control (like Flutter's height property)
extension View {
    func lineHeight(_ lineHeight: CGFloat, font: Font) -> some View {
        self.font(font)
            .lineSpacing(lineHeight - UIFont.preferredFont(forTextStyle: .body).lineHeight)
    }
}
