//
//  CustomTextField.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Custom Text Field
// Professional text input field with consistent styling
// Used for: Email, Password, Name, etc.

struct CustomTextField: View {
    let placeholder: String
    let icon: String?
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization
    
    @State private var isSecureVisible: Bool = false
    @FocusState private var isFocused: Bool
    
    init(
        placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Leading icon
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isFocused ? ColorPalette.primary : ColorPalette.textTertiary)
                    .frame(width: 20)
            }
            
            // Text field
            Group {
                if isSecure && !isSecureVisible {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled()
                }
            }
            .font(AppTypography.bodyMedium)
            .foregroundColor(ColorPalette.textPrimary)
            
            // Toggle password visibility
            if isSecure {
                Button(action: {
                    isSecureVisible.toggle()
                    HapticManager.selection()
                }) {
                    Image(systemName: isSecureVisible ? AppIcons.eye : AppIcons.eyeSlash)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorPalette.textTertiary)
                        .frame(width: 20)
                }
            }
        }
        .padding(.horizontal, Spacing.inputPaddingHorizontal)
        .padding(.vertical, Spacing.inputPaddingVertical)
        .background(
            RoundedRectangle(cornerRadius: Radius.input)
                .fill(ColorPalette.backgroundSecondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.input)
                .stroke(isFocused ? ColorPalette.primary : ColorPalette.border, lineWidth: isFocused ? 2 : 1)
        )
        .animation(.fast, value: isFocused)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        CustomTextField(
            placeholder: "Email",
            text: .constant(""),
            icon: AppIcons.mail,
            keyboardType: .emailAddress,
            autocapitalization: .never
        )
        
        CustomTextField(
            placeholder: "Password",
            text: .constant(""),
            icon: AppIcons.lock,
            isSecure: true
        )
        
        CustomTextField(
            placeholder: "Full Name",
            text: .constant(""),
            icon: AppIcons.user
        )
        
        CustomTextField(
            placeholder: "Search employees...",
            text: .constant(""),
            icon: AppIcons.search
        )
    }
    .padding()
    .background(ColorPalette.background)
}
