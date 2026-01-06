//
//  BaseCard.swift
//  TestSolz
//
//  Created by Mashaal Khan on 26/12/2025.
//

import SwiftUI

// MARK: - Base Card
// Foundation card component with consistent styling
// Used as a base for all card types in the app

struct BaseCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadow: ShadowStyle
    
    init(
        padding: CGFloat = Spacing.cardPadding,
        backgroundColor: Color = ColorPalette.cardBackground,
        cornerRadius: CGFloat = Radius.card,
        shadow: ShadowStyle = Shadows.card,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
    
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(shadow)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        BaseCard {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Card Title")
                    .font(AppTypography.titleMedium)
                    .foregroundColor(ColorPalette.textPrimary)
                
                Text("This is a base card with default styling. It provides consistent padding, background, and shadow.")
                    .font(AppTypography.bodySmall)
                    .foregroundColor(ColorPalette.textSecondary)
            }
        }
        
        BaseCard(backgroundColor: ColorPalette.primaryLight) {
            Text("Card with custom background")
                .font(AppTypography.bodyMedium)
        }
        
        BaseCard(padding: Spacing.lg, shadow: Shadows.md) {
            Text("Card with more padding and stronger shadow")
                .font(AppTypography.bodyMedium)
        }
    }
    .padding()
    .background(ColorPalette.backgroundSecondary)
}
