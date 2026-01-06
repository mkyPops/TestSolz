//
//  EmployeeListView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Employee List View
// Admin can view all employees and their attendance

struct EmployeeListView: View {
    @StateObject private var viewModel = AdminDashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Search Bar
                        searchBar
                        
                        // Employee List
                        employeeListSection
                        
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, Spacing.md)
                }
                .refreshable {
                    await viewModel.refresh()
                }
                
                // Loading overlay
                if viewModel.isLoading && viewModel.employeeAttendances.isEmpty {
                    loadingOverlay
                }
            }
            .navigationTitle("Employees")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.fetchAttendanceData()
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: AppIcons.search)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ColorPalette.textTertiary)
            
            TextField("Search employees...", text: $viewModel.searchText)
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textPrimary)
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                    HapticManager.selection()
                }) {
                    Image(systemName: AppIcons.close)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorPalette.textTertiary)
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
                .stroke(ColorPalette.border, lineWidth: 1)
        )
    }
    
    // MARK: - Employee List Section
    private var employeeListSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("All Employees (\(viewModel.filteredEmployees.count))")
                .font(AppTypography.labelMedium)
                .foregroundColor(ColorPalette.textSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            if viewModel.filteredEmployees.isEmpty {
                emptyState
            } else {
                ForEach(viewModel.filteredEmployees) { employeeAttendance in
                    employeeCard(employeeAttendance)
                }
            }
        }
    }
    
    // MARK: - Employee Card
    private func employeeCard(_ employeeAttendance: EmployeeAttendance) -> some View {
        BaseCard {
            HStack(spacing: Spacing.md) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(employeeAttendance.statusColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Text(String(employeeAttendance.employee.name.prefix(1)))
                        .font(AppTypography.titleMedium)
                        .foregroundColor(employeeAttendance.statusColor)
                }
                
                // Employee Info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(employeeAttendance.employee.name)
                        .font(AppTypography.titleSmall)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Text(employeeAttendance.employee.department ?? "No Department")
                        .font(AppTypography.captionMedium)
                        .foregroundColor(ColorPalette.textTertiary)
                }
                
                Spacer()
                
                // Status
                VStack(alignment: .trailing, spacing: Spacing.xxs) {
                    Text(employeeAttendance.statusText)
                        .font(AppTypography.labelSmall)
                        .foregroundColor(employeeAttendance.statusColor)
                    
                    Text(employeeAttendance.checkInTimeText)
                        .font(AppTypography.captionSmall)
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: AppIcons.search)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(ColorPalette.textTertiary)
            
            Text("No employees found")
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
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
    EmployeeListView()
}
