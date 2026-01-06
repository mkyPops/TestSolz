//
//  AttendanceHistoryView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Attendance History View
// Calendar view showing employee's past attendance with stats

struct AttendanceHistoryView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = AttendanceHistoryViewModel()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    let weekDays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    var body: some View {
        ZStack {
            ColorPalette.backgroundSecondary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Header
                    headerSection
                    
                    // Stats Grid
                    statsGrid
                    
                    // Calendar
                    calendarSection
                    
                    // Selected Date Detail
                    if viewModel.selectedDate != nil {
                        selectedDateDetail
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.screenVertical)
            }
            
            if viewModel.isLoading && viewModel.attendanceRecords.isEmpty {
                loadingOverlay
            }
        }
        .task {
            await viewModel.fetchHistory(userId: authViewModel.currentUser?.id ?? "")
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Attendance History")
                    .font(AppTypography.headlineLarge)
                    .foregroundColor(ColorPalette.textPrimary)
                
                Text("Your attendance records")
                    .font(AppTypography.bodySmall)
                    .foregroundColor(ColorPalette.textSecondary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Stats Grid
    private var statsGrid: some View {
        HStack(spacing: Spacing.md) {
            MetricCard(
                icon: AppIcons.calendar,
                title: "Present",
                value: "\(viewModel.totalDaysPresent)",
                subtitle: "This month",
                accentColor: ColorPalette.success
            )
            
            MetricCard(
                icon: AppIcons.clock,
                title: "Avg Hours",
                value: String(format: "%.1fh", viewModel.averageHours),
                subtitle: "Per day",
                accentColor: ColorPalette.primary
            )
        }
    }
    
    // MARK: - Calendar Section
    private var calendarSection: some View {
        BaseCard {
            VStack(spacing: Spacing.md) {
                // Month Navigation
                HStack {
                    Button(action: { viewModel.previousMonth() }) {
                        Image(systemName: AppIcons.back)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(ColorPalette.primary)
                            .frame(width: 32, height: 32)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.monthString)
                        .font(AppTypography.titleMedium)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { viewModel.nextMonth() }) {
                        Image(systemName: AppIcons.forward)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(ColorPalette.primary)
                            .frame(width: 32, height: 32)
                    }
                }
                
                // Week days header
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(weekDays, id: \.self) { day in
                        Text(day)
                            .font(AppTypography.captionSmall)
                            .foregroundColor(ColorPalette.textTertiary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Calendar grid
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.daysInMonth, id: \.self) { date in
                        dayCell(date: date)
                    }
                }
            }
        }
    }
    
    // MARK: - Day Cell
    private func dayCell(date: Date) -> some View {
        let day = Calendar.current.component(.day, from: date)
        let hasAttendance = viewModel.hasAttendanceForDate(date)
        let status = viewModel.getStatusForDate(date)
        let isSelected = viewModel.selectedDate != nil && Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate!)
        let isToday = Calendar.current.isDateInToday(date)
        let isFuture = date > Date()
        
        return Button(action: {
            if hasAttendance {
                viewModel.selectedDate = date
                HapticManager.selection()
            }
        }) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(AppTypography.bodySmall)
                    .foregroundColor(
                        isFuture ? ColorPalette.textTertiary :
                        isSelected ? .white :
                        isToday ? ColorPalette.primary :
                        ColorPalette.textPrimary
                    )
                
                // Status indicator dot
                Circle()
                    .fill(status?.color ?? Color.clear)
                    .frame(width: 6, height: 6)
                    .opacity(hasAttendance ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isSelected ? ColorPalette.primary :
                        isToday ? ColorPalette.primaryLight :
                        Color.clear
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday && !isSelected ? ColorPalette.primary : Color.clear, lineWidth: 1)
            )
        }
        .disabled(!hasAttendance || isFuture)
    }
    
    // MARK: - Selected Date Detail
    private var selectedDateDetail: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack {
                    Text(viewModel.selectedDate!.formatted(style: "date"))
                        .font(AppTypography.titleMedium)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.selectedDate = nil
                        HapticManager.selection()
                    }) {
                        Image(systemName: AppIcons.close)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(ColorPalette.textTertiary)
                    }
                }
                
                Divider()
                    .background(ColorPalette.divider)
                
                if let attendance = viewModel.selectedDateAttendance {
                    VStack(spacing: Spacing.sm) {
                        detailRow(
                            icon: AppIcons.checkIn,
                            label: "Check In",
                            value: attendance.checkInTime.formatted(style: "time"),
                            color: ColorPalette.success
                        )
                        
                        if let checkOutTime = attendance.checkOutTime {
                            detailRow(
                                icon: AppIcons.checkOut,
                                label: "Check Out",
                                value: checkOutTime.formatted(style: "time"),
                                color: ColorPalette.textSecondary
                            )
                            
                            if let hours = attendance.hoursWorked {
                                detailRow(
                                    icon: AppIcons.clock,
                                    label: "Hours Worked",
                                    value: String(format: "%.1f hours", hours),
                                    color: ColorPalette.primary
                                )
                            }
                        }
                        
                        detailRow(
                            icon: AppIcons.info,
                            label: "Status",
                            value: attendance.status.displayName,
                            color: attendance.status.color
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Detail Row
    private func detailRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textPrimary)
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: ColorPalette.primary))
                .scaleEffect(1.5)
        }
    }
}

// MARK: - Preview
#Preview {
    AttendanceHistoryView()
        .environmentObject(AuthenticationViewModel())
}
