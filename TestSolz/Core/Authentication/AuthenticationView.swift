//
//  AuthenticationView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Authentication View
// Login screen for employees and admins
// Clean, professional design with brand colors

struct AuthenticationView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            // Background
            ColorPalette.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Spacer()
                        .frame(height: Spacing.xxxl)
                    
                    // Logo and Title
                    VStack(spacing: Spacing.md) {
                        // Logo placeholder (you can add your actual logo here)
                        ZStack {
                            Circle()
                                .fill(ColorPalette.primaryLight)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "gearshape.2.fill")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(ColorPalette.primary)
                        }
                        
                        VStack(spacing: Spacing.xs) {
                            Text("TestSolz")
                                .font(AppTypography.displayMedium)
                                .foregroundColor(ColorPalette.textPrimary)
                            
                            Text("Attendance Management")
                                .font(AppTypography.bodyMedium)
                                .foregroundColor(ColorPalette.textSecondary)
                        }
                    }
                    
                    // Login Form
                    VStack(spacing: Spacing.lg) {
                        VStack(spacing: Spacing.md) {
                            // Email field
                            CustomTextField(
                                placeholder: "Email",
                                text: $viewModel.email,
                                icon: AppIcons.mail,
                                keyboardType: .emailAddress,
                                autocapitalization: .never
                            )
                            
                            // Password field
                            CustomTextField(
                                placeholder: "Password",
                                text: $viewModel.password,
                                icon: AppIcons.lock,
                                isSecure: true
                            )
                        }
                        
                        // Error message
                        if let errorMessage = viewModel.errorMessage {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: AppIcons.error)
                                    .font(.system(size: 14, weight: .semibold))
                                Text(errorMessage)
                                    .font(AppTypography.bodySmall)
                            }
                            .foregroundColor(ColorPalette.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, Spacing.xs)
                        }
                        
                        // Login button
                        PrimaryButton(
                            "Sign In",
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.login()
                            }
                        }
                        
                        // Demo credentials hint
                        VStack(spacing: Spacing.xs) {
                            Text("Demo Credentials:")
                                .font(AppTypography.captionSmall)
                                .foregroundColor(ColorPalette.textTertiary)
                            
                            Text("Employee: any@testsolz.com / test123")
                                .font(AppTypography.captionSmall)
                                .foregroundColor(ColorPalette.textTertiary)
                            
                            Text("Admin: admin@testsolz.com / admin123")
                                .font(AppTypography.captionSmall)
                                .foregroundColor(ColorPalette.textTertiary)
                        }
                        .padding(.top, Spacing.sm)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AuthenticationView()
}
