//
//  ProfileView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Profile View
// User profile and settings screen - Minimalistic and professional

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        ZStack {
            ColorPalette.backgroundSecondary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Profile Header
                    profileHeader
                    
                    // Account Section
                    accountSection
                    
                    // Logout Button
                    logoutButton
                    
                    // Version
                    versionInfo
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.lg)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ColorPalette.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .alert("Logout", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                authViewModel.logout()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        BaseCard(padding: Spacing.lg) {
            VStack(spacing: Spacing.md) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(ColorPalette.primaryLight)
                        .frame(width: 96, height: 96)
                    
                    Text(authViewModel.currentUser?.name.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(ColorPalette.primary)
                }
                
                // User Info
                VStack(spacing: Spacing.xs) {
                    Text(authViewModel.currentUser?.name ?? "User")
                        .font(AppTypography.headlineLarge)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Text(authViewModel.currentUser?.email ?? "")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(ColorPalette.textSecondary)
                    
                    // Role Badge
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: authViewModel.currentUser?.role == .admin ? AppIcons.users : AppIcons.user)
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text(authViewModel.currentUser?.role.displayName ?? "")
                            .font(AppTypography.labelSmall)
                    }
                    .foregroundColor(ColorPalette.primary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(ColorPalette.primaryLight)
                    .cornerRadius(Radius.sm)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        VStack(spacing: 0) {
            settingsRow(
                icon: AppIcons.user,
                title: "Edit Profile",
                subtitle: "Update your personal information",
                showDivider: true
            ) {
                // TODO: Navigate to edit profile
                print("Edit Profile tapped")
            }
            
            settingsRow(
                icon: AppIcons.lock,
                title: "Change Password",
                subtitle: "Update your password",
                showDivider: authViewModel.currentUser?.department != nil
            ) {
                // TODO: Navigate to change password
                print("Change Password tapped")
            }
            
            if let department = authViewModel.currentUser?.department {
                settingsRow(
                    icon: AppIcons.building,
                    title: "Department",
                    subtitle: department,
                    showDivider: false,
                    showChevron: false
                ) { }
            }
        }
        .background(ColorPalette.cardBackground)
        .cornerRadius(Radius.card)
        .shadow(Shadows.card)
    }
    
    // MARK: - Settings Row
    private func settingsRow(
        icon: String,
        title: String,
        subtitle: String,
        showDivider: Bool,
        showChevron: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            VStack(spacing: 0) {
                HStack(spacing: Spacing.md) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(ColorPalette.primaryLight)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(ColorPalette.primary)
                    }
                    
                    // Text
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(title)
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(ColorPalette.textPrimary)
                        
                        Text(subtitle)
                            .font(AppTypography.captionMedium)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Chevron
                    if showChevron {
                        Image(systemName: AppIcons.forward)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ColorPalette.textTertiary)
                    }
                }
                .padding(Spacing.md)
                
                // Divider
                if showDivider {
                    Divider()
                        .background(ColorPalette.divider)
                        .padding(.leading, 68)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            HapticManager.impact(style: .medium)
            showLogoutConfirmation = true
        }) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "arrow.right.square")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Logout")
                    .font(AppTypography.buttonMedium)
            }
            .foregroundColor(ColorPalette.error)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(ColorPalette.errorLight)
            .cornerRadius(Radius.button)
        }
    }
    
    // MARK: - Version Info
    private var versionInfo: some View {
        VStack(spacing: Spacing.xxs) {
            Text("TestSolz")
                .font(AppTypography.captionMedium)
                .foregroundColor(ColorPalette.textTertiary)
            
            Text("Version 1.0.0")
                .font(AppTypography.captionSmall)
                .foregroundColor(ColorPalette.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Spacing.md)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
