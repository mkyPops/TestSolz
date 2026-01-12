//
//  EmployeeHomeView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Employee Home View
// Main screen for employees - check in/out and view status

struct EmployeeHomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var checkInViewModel = CheckInViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Header
                        headerSection
                        
                        // Status Card
                        if let attendance = checkInViewModel.currentAttendance {
                            currentStatusCard(attendance: attendance)
                        } else {
                            notCheckedInCard
                        }
                        
                        // Check In/Out Button
                        actionButton
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // History Button
                        historyButton
                        
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, Spacing.screenVertical)
                }
                
                // Success message overlay
                if checkInViewModel.showSuccessMessage {
                    successOverlay
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Welcome back,")
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                
                Text(authViewModel.currentUser?.name ?? "Employee")
                    .font(AppTypography.headlineLarge)
                    .foregroundColor(ColorPalette.textPrimary)
            }
            
            Spacer()
            
            // Logout button only
            Button(action: {
                authViewModel.logout()
            }) {
                Image(systemName: AppIcons.user)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorPalette.textSecondary)
            }
        }
    }
    
    // MARK: - Current Status Card
    private func currentStatusCard(attendance: Attendance) -> some View {
        StatusCard(
            icon: attendance.isCheckedOut ? AppIcons.checkOut : AppIcons.checkIn,
            title: attendance.isCheckedOut ? "Checked Out" : "Checked In",
            subtitle: attendance.isCheckedOut
                ? "Today at \(attendance.checkOutTime!.formatted(style: "time"))"
                : "Today at \(attendance.checkInTime.formatted(style: "time"))",
            statusColor: attendance.isCheckedOut ? ColorPalette.textSecondary : ColorPalette.success
        )
    }
    
    // MARK: - Not Checked In Card
    private var notCheckedInCard: some View {
        StatusCard(
            icon: AppIcons.clock,
            title: "Not Checked In",
            subtitle: "Tap the button below to check in",
            statusColor: ColorPalette.textTertiary
        )
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Group {
            if checkInViewModel.isCheckedIn {
                // Check Out Button
                PrimaryButton(
                    "Check Out",
                    icon: AppIcons.checkOut,
                    isLoading: checkInViewModel.isLoading
                ) {
                    Task {
                        await checkInViewModel.checkOut()
                    }
                }
            } else {
                // Check In Button
                PrimaryButton(
                    "Check In",
                    icon: AppIcons.checkIn,
                    isLoading: checkInViewModel.isLoading
                ) {
                    Task {
                        await checkInViewModel.checkIn(
                            userId: authViewModel.currentUser?.id ?? ""
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Today")
                .font(AppTypography.labelMedium)
                .foregroundColor(ColorPalette.textSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            HStack(spacing: Spacing.md) {
                // Hours worked
                MetricCard(
                    icon: AppIcons.clock,
                    title: "Hours Worked",
                    value: checkInViewModel.currentAttendance?.hoursWorked != nil
                        ? String(format: "%.1fh", checkInViewModel.currentAttendance!.hoursWorked!)
                        : "0h",
                    accentColor: ColorPalette.primary
                )
                
                // Status
                MetricCard(
                    icon: AppIcons.checkIn,
                    title: "Status",
                    value: checkInViewModel.currentAttendance?.status.displayName ?? "Absent",
                    accentColor: checkInViewModel.currentAttendance?.status.color ?? ColorPalette.textTertiary
                )
            }
        }
    }
    
    // MARK: - History Card Button
    private var historyButton: some View {
        NavigationLink(destination: AttendanceHistoryView()) {
            BaseCard(padding: Spacing.md) {
                HStack(spacing: Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(ColorPalette.primaryLight)
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: AppIcons.calendar)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(ColorPalette.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("View History")
                            .font(AppTypography.titleSmall)
                            .foregroundColor(ColorPalette.textPrimary)
                        
                        Text("See your past attendance")
                            .font(AppTypography.captionMedium)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: AppIcons.forward)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Success Overlay
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(ColorPalette.success)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: AppIcons.success)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(checkInViewModel.isCheckedIn ? "Checked In!" : "Checked Out!")
                    .font(AppTypography.headlineMedium)
                    .foregroundColor(.white)
            }
            .padding(Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(Color.black.opacity(0.8))
            )
        }
        .transition(.opacity)
        .animation(.normal, value: checkInViewModel.showSuccessMessage)
    }
}

// MARK: - Preview
#Preview {
    EmployeeHomeView()
        .environmentObject(AuthenticationViewModel())
}
