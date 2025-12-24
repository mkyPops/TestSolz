//
//  ColorPalette.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - TestSolz Color Palette
// Brand-aligned color system based on company logo
// Primary: Cyan/Turquoise (gear icon color)
// Professional, minimalistic, enterprise-grade

struct ColorPalette {
    
    // MARK: - Brand Colors (from logo)
    static let primary = Color(hex: "#00D9D9")        // Cyan - main brand color (gears)
    static let primaryDark = Color(hex: "#00B8B8")    // Darker cyan for pressed states
    static let primaryLight = Color(hex: "#E0F9F9")   // Very light cyan for backgrounds
    static let primarySubtle = Color(hex: "#B3F0F0")  // Subtle cyan for highlights
    
    static let dark = Color(hex: "#2D2D2D")           // Dark charcoal (logo background)
    static let darkSecondary = Color(hex: "#3D3D3D")  // Slightly lighter dark
    
    // MARK: - Semantic Colors (professional, minimal)
    static let success = Color(hex: "#00D9A3")        // Teal-green - for check-in success
    static let successLight = Color(hex: "#E0FAF3")   // Light teal background
    
    static let warning = Color(hex: "#FFB84D")        // Warm amber - for warnings
    static let warningLight = Color(hex: "#FFF4E0")   // Light amber background
    
    static let error = Color(hex: "#FF6B6B")          // Coral red - for errors
    static let errorLight = Color(hex: "#FFE8E8")     // Light coral background
    
    static let info = Color(hex: "#00D9D9")           // Using brand cyan for info
    static let infoLight = Color(hex: "#E0F9F9")      // Light cyan background
    
    // MARK: - Neutral Colors (clean, minimal)
    static let background = Color(hex: "#FFFFFF")     // Pure white
    static let backgroundSecondary = Color(hex: "#F9FAFB") // Off-white for surfaces
    static let backgroundTertiary = Color(hex: "#F3F4F6")  // Light gray for sections
    
    static let surface = Color(hex: "#FFFFFF")        // White cards/surfaces
    static let surfaceElevated = Color(hex: "#FAFBFC") // Slightly elevated surfaces
    
    // MARK: - Text Colors (high readability)
    static let textPrimary = Color(hex: "#1A1A1A")    // Almost black - main text
    static let textSecondary = Color(hex: "#6B7280")  // Gray - secondary text
    static let textTertiary = Color(hex: "#9CA3AF")   // Light gray - placeholder
    static let textOnDark = Color(hex: "#FFFFFF")     // White text on dark backgrounds
    static let textOnPrimary = Color(hex: "#FFFFFF")  // White text on cyan
    
    // MARK: - Border & Divider Colors
    static let border = Color(hex: "#E5E7EB")         // Light gray border
    static let borderMedium = Color(hex: "#D1D5DB")   // Medium gray border
    static let borderDark = Color(hex: "#9CA3AF")     // Darker border for emphasis
    
    static let divider = Color(hex: "#F3F4F6")        // Very subtle dividers
    
    // MARK: - Status Colors (attendance-specific)
    static let statusCheckedIn = success              // Teal-green for checked in
    static let statusCheckedOut = Color(hex: "#9CA3AF") // Gray for checked out
    static let statusLate = warning                   // Amber for late arrival
    static let statusAbsent = Color(hex: "#D1D5DB")   // Light gray for absent
    static let statusOnTime = primary                 // Cyan for on-time
    
    // MARK: - Interactive Elements
    static let buttonPrimary = primary                // Cyan buttons
    static let buttonPrimaryPressed = primaryDark     // Darker when pressed
    static let buttonSecondary = Color(hex: "#F3F4F6") // Light gray secondary buttons
    static let buttonSecondaryText = textPrimary      // Dark text on secondary buttons
    
    static let buttonDisabled = Color(hex: "#E5E7EB") // Disabled button background
    static let buttonDisabledText = Color(hex: "#9CA3AF") // Disabled button text
    
    // MARK: - Card & Shadow
    static let cardBackground = surface
    static let cardShadow = Color.black.opacity(0.04) // Very subtle shadow
    static let cardShadowHover = Color.black.opacity(0.08) // Slightly stronger on hover
    
    // MARK: - Accent Colors (optional, for variety)
    static let accentPurple = Color(hex: "#A78BFA")   // Soft purple for admin features
    static let accentBlue = Color(hex: "#60A5FA")     // Soft blue for analytics
    static let accentGreen = Color(hex: "#34D399")    // Fresh green for positive metrics
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
