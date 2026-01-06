//
//  SecondaryButton.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Secondary Button
// Secondary action button with subtle styling
// Used for: Cancel, Back, View Details, etc.

struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    let fullWidth: Bool
    
    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        fullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.fullWidth = fullWidth
    }
    
    var body: some View {
        Button(action: {
            if !isDisabled && !isLoading {
                HapticManager.impact(style: .light)
                action()
            }
        }) {
            HStack(spacing: Spacing.iconTextSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: ColorPalette.textSecondary))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(AppTypography.labelMedium)
                    }
                    
                    Text(title)
                        .font(AppTypography.buttonMedium)
                }
            }
            .foregroundColor(isDisabled ? ColorPalette.buttonDisabledText : ColorPalette.textPrimary)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, Spacing.buttonPaddingHorizontal)
            .padding(.vertical, Spacing.buttonPaddingVertical)
            .background(
                RoundedRectangle(cornerRadius: Radius.button)
                    .fill(isDisabled ? ColorPalette.buttonDisabled : ColorPalette.buttonSecondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.button)
                    .stroke(isDisabled ? ColorPalette.border : ColorPalette.borderMedium, lineWidth: 1)
            )
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .disabled(isDisabled || isLoading)
        .animation(.fast, value: isLoading)
        .animation(.fast, value: isDisabled)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        // Normal state
        SecondaryButton("Cancel") {
            print("Cancelled")
        }
        
        // With icon
        SecondaryButton("View History", icon: AppIcons.calendar) {
            print("View history")
        }
        
        // Loading state
        SecondaryButton("Loading...", isLoading: true) {
            print("Loading...")
        }
        
        // Disabled state
        SecondaryButton("Disabled", isDisabled: true) {
            print("Won't fire")
        }
        
        // Compact
        SecondaryButton("Back", icon: AppIcons.back, fullWidth: false) {
            print("Go back")
        }
    }
    .padding()
}
