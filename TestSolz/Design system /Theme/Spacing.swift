//
//  Spacing.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Spacing System
// Consistent spacing scale for the entire app
// Based on 4px base unit (like 8pt grid system)
// Prevents random padding values scattered throughout code

struct Spacing {
    
    // MARK: - Base Spacing Scale
    static let xxxs: CGFloat = 2      // Micro spacing (icon padding, badges)
    static let xxs: CGFloat = 4       // Tiny spacing (between related elements)
    static let xs: CGFloat = 8        // Extra small (tight groups)
    static let sm: CGFloat = 12       // Small (compact layouts)
    static let md: CGFloat = 16       // Medium (default padding) - MOST COMMON
    static let lg: CGFloat = 24       // Large (section spacing)
    static let xl: CGFloat = 32       // Extra large (major sections)
    static let xxl: CGFloat = 48      // Double extra large (screen sections)
    static let xxxl: CGFloat = 64     // Massive spacing (hero sections)
    
    // MARK: - Semantic Spacing (named by purpose)
    
    // Card & Container Padding
    static let cardPadding: CGFloat = md           // 16px - standard card padding
    static let cardPaddingCompact: CGFloat = sm    // 12px - compact card padding
    static let cardPaddingGenerous: CGFloat = lg   // 24px - generous card padding
    
    // Screen Padding
    static let screenHorizontal: CGFloat = md      // 16px - left/right screen edges
    static let screenVertical: CGFloat = lg        // 24px - top/bottom screen edges
    
    // List & Stack Spacing
    static let listItemSpacing: CGFloat = xs       // 8px - between list items
    static let stackSpacing: CGFloat = sm          // 12px - between stacked elements
    static let sectionSpacing: CGFloat = lg        // 24px - between major sections
    
    // Button Spacing
    static let buttonPaddingHorizontal: CGFloat = lg  // 24px - button left/right padding
    static let buttonPaddingVertical: CGFloat = sm    // 12px - button top/bottom padding
    static let buttonSpacing: CGFloat = xs            // 8px - between buttons
    
    // Form & Input Spacing
    static let inputPaddingHorizontal: CGFloat = md   // 16px - input field padding
    static let inputPaddingVertical: CGFloat = sm     // 12px - input field padding
    static let formFieldSpacing: CGFloat = md         // 16px - between form fields
    static let formSectionSpacing: CGFloat = xl       // 32px - between form sections
    
    // Icon & Text Spacing
    static let iconTextSpacing: CGFloat = xs          // 8px - icon next to text
    static let badgeSpacing: CGFloat = xxs            // 4px - badge padding
    
    // Divider & Separator
    static let dividerSpacing: CGFloat = md           // 16px - around dividers
}

// MARK: - Edge Insets Presets
// Common padding combinations for views
// Usage: .padding(EdgeInsetsPresets.card)

struct EdgeInsetsPresets {
    
    // Card Insets
    static let card = EdgeInsets(
        top: Spacing.cardPadding,
        leading: Spacing.cardPadding,
        bottom: Spacing.cardPadding,
        trailing: Spacing.cardPadding
    )
    
    static let cardCompact = EdgeInsets(
        top: Spacing.cardPaddingCompact,
        leading: Spacing.cardPaddingCompact,
        bottom: Spacing.cardPaddingCompact,
        trailing: Spacing.cardPaddingCompact
    )
    
    // Screen Insets
    static let screen = EdgeInsets(
        top: Spacing.screenVertical,
        leading: Spacing.screenHorizontal,
        bottom: Spacing.screenVertical,
        trailing: Spacing.screenHorizontal
    )
    
    static let screenHorizontalOnly = EdgeInsets(
        top: 0,
        leading: Spacing.screenHorizontal,
        bottom: 0,
        trailing: Spacing.screenHorizontal
    )
    
    // Button Insets
    static let button = EdgeInsets(
        top: Spacing.buttonPaddingVertical,
        leading: Spacing.buttonPaddingHorizontal,
        bottom: Spacing.buttonPaddingVertical,
        trailing: Spacing.buttonPaddingHorizontal
    )
    
    static let buttonCompact = EdgeInsets(
        top: Spacing.xs,
        leading: Spacing.md,
        bottom: Spacing.xs,
        trailing: Spacing.md
    )
    
    // Input Field Insets
    static let input = EdgeInsets(
        top: Spacing.inputPaddingVertical,
        leading: Spacing.inputPaddingHorizontal,
        bottom: Spacing.inputPaddingVertical,
        trailing: Spacing.inputPaddingHorizontal
    )
}

// MARK: - Spacing Convenience Extension
// Shorthand for common spacing patterns
// Usage: VStack(spacing: .md) or .padding(.lg)

extension CGFloat {
    static let xxxs = Spacing.xxxs
    static let xxs = Spacing.xxs
    static let xs = Spacing.xs
    static let sm = Spacing.sm
    static let md = Spacing.md
    static let lg = Spacing.lg
    static let xl = Spacing.xl
    static let xxl = Spacing.xxl
    static let xxxl = Spacing.xxxl
}

