//
//  PrimaryButton.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - Primary Button
// Main call-to-action button with brand color
// Used for: Check In, Check Out, Submit, Confirm, etc.

struct PrimaryButton: View {
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
                HapticManager.impact(style: .medium)
                action()
            }
        }) {
            HStack(spacing: Spacing.iconTextSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: ColorPalette.textOnPrimary))
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
            .foregroundColor(isDisabled ? ColorPalette.buttonDisabledText : ColorPalette.textOnPrimary)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, Spacing.buttonPaddingHorizontal)
            .padding(.vertical, Spacing.buttonPaddingVertical)
            .background(
                RoundedRectangle(cornerRadius: Radius.button)
                    .fill(isDisabled ? ColorPalette.buttonDisabled : ColorPalette.primary)
            )
            .shadow(isDisabled ? Shadows.none : Shadows.button)
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
        PrimaryButton("Check In", icon: AppIcons.checkIn) {
            print("Checked in!")
        }
        
        // With icon
        PrimaryButton("Check Out", icon: AppIcons.checkOut) {
            print("Checked out!")
        }
        
        // Loading state
        PrimaryButton("Processing...", isLoading: true) {
            print("Loading...")
        }
        
        // Disabled state
        PrimaryButton("Disabled Button", isDisabled: true) {
            print("This won't fire")
        }
        
        // Compact (not full width)
        PrimaryButton("Compact", fullWidth: false) {
            print("Compact button")
        }
    }
    .padding()
}
