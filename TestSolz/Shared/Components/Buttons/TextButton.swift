//
//  TextButton.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Text Button
// Minimal text-only button for tertiary actions
// Used for: Skip, Learn More, Forgot Password, etc.

struct TextButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isDisabled: Bool
    let color: Color
    
    init(
        _ title: String,
        icon: String? = nil,
        color: Color = ColorPalette.primary,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                HapticManager.selection()
                action()
            }
        }) {
            HStack(spacing: Spacing.xxs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(AppTypography.labelSmall)
                }
                
                Text(title)
                    .font(AppTypography.labelMedium)
            }
            .foregroundColor(isDisabled ? ColorPalette.textTertiary : color)
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        TextButton("Forgot Password?") {
            print("Forgot password")
        }
        
        TextButton("Learn More", icon: AppIcons.info) {
            print("Learn more")
        }
        
        TextButton("Skip", color: ColorPalette.textSecondary) {
            print("Skip")
        }
        
        TextButton("Disabled", isDisabled: true) {
            print("Won't fire")
        }
    }
    .padding()
}
