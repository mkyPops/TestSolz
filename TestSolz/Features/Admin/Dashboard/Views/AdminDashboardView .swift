//
//  AdminDashboardView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Admin Dashboard View
// Main dashboard for HR/Admin to monitor attendance metrics

struct AdminDashboardView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = AdminDashboardViewModel()
    
    var body: some View {
        ZStack {
            // Background
            ColorPalette.backgroundSecondary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Header
                    headerSection
                    
                    // Metrics Grid
                    metricsGrid
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.screenVertical)
                .padding(.bottom, 100)
            }
            .refreshable {
                await viewModel.refresh()
            }
            
            // Loading overlay
            if viewModel.isLoading && viewModel.employeeAttendances.isEmpty {
                loadingOverlay
            }
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(ColorPalette.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: AppIcons.user)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorPalette.textSecondary)
                }
            }
        }
        .onAppear {
            if viewModel.employeeAttendances.isEmpty {
                Task {
                    await viewModel.fetchAttendanceData()
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Overview")
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                
                Text("Today's Metrics")
                    .font(AppTypography.headlineLarge)
                    .foregroundColor(ColorPalette.textPrimary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Metrics Grid
    private var metricsGrid: some View {
        VStack(spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                MetricCard(
                    icon: AppIcons.users,
                    title: "Present Today",
                    value: "\(viewModel.presentCount)",
                    subtitle: "Out of \(viewModel.totalEmployees) employees",
                    accentColor: ColorPalette.success
                )
                
                MetricCard(
                    icon: AppIcons.clock,
                    title: "Late Arrivals",
                    value: "\(viewModel.lateArrivals)",
                    subtitle: "Today",
                    accentColor: ColorPalette.warning
                )
            }
            
            HStack(spacing: Spacing.md) {
                MetricCard(
                    icon: AppIcons.checkOut,
                    title: "Checked Out",
                    value: "\(viewModel.checkedOutCount)",
                    subtitle: "Employees",
                    accentColor: ColorPalette.textSecondary
                )
                
                MetricCard(
                    icon: AppIcons.chart,
                    title: "Attendance",
                    value: String(format: "%.0f%%", viewModel.attendanceRate),
                    subtitle: "Today's rate",
                    accentColor: ColorPalette.primary
                )
            }
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
    NavigationStack {
        AdminDashboardView()
            .environmentObject(AuthenticationViewModel())
    }
}
