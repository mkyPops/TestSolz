//
//  EmployeeRequestsView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Employee Requests View
// Employee can view and create leave/late requests

struct EmployeeRequestsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = RequestsViewModel()
    
    // Create leave state
    @State private var newLeaveType: LeaveType = .vacation
    @State private var newLeaveStartDate = Date()
    @State private var newLeaveEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var newLeaveReason = ""
    
    // Create late state
    @State private var newLateDate = Date()
    @State private var newLateTime = Date()
    @State private var newLateReason = ""
    
    @State private var selectedFilter: RequestStatus? = nil
    
    var filteredRequests: [LeaveRequest] {
        if let filter = selectedFilter {
            return viewModel.requests.filter { $0.status == filter }
        }
        return viewModel.requests
    }
    
    var body: some View {
        ZStack {
            ColorPalette.backgroundSecondary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Action Buttons
                    actionButtons
                    
                    // Filter Tabs
                    filterSection
                    
                    // Requests List
                    requestsList
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, Spacing.md)
                .padding(.bottom, 100) // Space for tab bar
            }
            .refreshable {
                await viewModel.fetchRequests(userId: authViewModel.currentUser?.id ?? "")
            }
            
            // Loading overlay
            if viewModel.isLoading && viewModel.requests.isEmpty {
                loadingOverlay
            }
        }
        .navigationTitle("Requests")
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
        .task {
            await viewModel.fetchRequests(userId: authViewModel.currentUser?.id ?? "")
        }
        .sheet(isPresented: $viewModel.showCreateLeave) {
            CreateLeaveView(
                leaveType: $newLeaveType,
                startDate: $newLeaveStartDate,
                endDate: $newLeaveEndDate,
                reason: $newLeaveReason
            ) {
                Task {
                    await viewModel.createLeaveRequest(
                        userId: authViewModel.currentUser?.id ?? "",
                        userName: authViewModel.currentUser?.name ?? "",
                        userDepartment: authViewModel.currentUser?.department,
                        leaveType: newLeaveType,
                        startDate: newLeaveStartDate,
                        endDate: newLeaveEndDate,
                        reason: newLeaveReason
                    )
                    // Reset
                    newLeaveReason = ""
                    newLeaveStartDate = Date()
                    newLeaveEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                }
            }
        }
        .sheet(isPresented: $viewModel.showCreateLate) {
            CreateLateView(
                date: $newLateDate,
                time: $newLateTime,
                reason: $newLateReason
            ) {
                Task {
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    let timeString = formatter.string(from: newLateTime)
                    
                    await viewModel.createLateRequest(
                        userId: authViewModel.currentUser?.id ?? "",
                        userName: authViewModel.currentUser?.name ?? "",
                        userDepartment: authViewModel.currentUser?.department,
                        date: newLateDate,
                        expectedTime: timeString,
                        reason: newLateReason
                    )
                    // Reset
                    newLateReason = ""
                    newLateDate = Date()
                    newLateTime = Date()
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: Spacing.md) {
            Button(action: {
                viewModel.showCreateLeave = true
            }) {
                VStack(spacing: Spacing.xs) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(ColorPalette.primary)
                    
                    Text("Request Leave")
                        .font(AppTypography.labelSmall)
                        .foregroundColor(ColorPalette.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.lg)
                .background(ColorPalette.cardBackground)
                .cornerRadius(Radius.card)
                .shadow(Shadows.card)
            }
            
            Button(action: {
                viewModel.showCreateLate = true
            }) {
                VStack(spacing: Spacing.xs) {
                    Image(systemName: "clock.badge.exclamationmark")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(ColorPalette.warning)
                    
                    Text("Report Late")
                        .font(AppTypography.labelSmall)
                        .foregroundColor(ColorPalette.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.lg)
                .background(ColorPalette.cardBackground)
                .cornerRadius(Radius.card)
                .shadow(Shadows.card)
            }
        }
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("My Requests")
                .font(AppTypography.labelMedium)
                .foregroundColor(ColorPalette.textSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    filterChip(title: "All (\(viewModel.requests.count))", filter: nil)
                    filterChip(title: "Pending (\(viewModel.pendingCount))", filter: .pending)
                    filterChip(title: "Approved (\(viewModel.approvedCount))", filter: .approved)
                    filterChip(title: "Rejected (\(viewModel.rejectedCount))", filter: .rejected)
                }
            }
        }
    }
    
    private func filterChip(title: String, filter: RequestStatus?) -> some View {
        Button(action: {
            selectedFilter = filter
            HapticManager.selection()
        }) {
            Text(title)
                .font(AppTypography.labelSmall)
                .foregroundColor(selectedFilter == filter ? .white : ColorPalette.textSecondary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(selectedFilter == filter ? ColorPalette.primary : ColorPalette.cardBackground)
                .cornerRadius(Radius.button)
        }
    }
    
    // MARK: - Requests List
    private var requestsList: some View {
        VStack(spacing: Spacing.md) {
            if filteredRequests.isEmpty {
                emptyState
            } else {
                ForEach(filteredRequests) { request in
                    RequestCard(
                        request: request,
                        showEmployeeName: false,
                        onDelete: request.status == .pending ? {
                            Task {
                                await viewModel.deleteRequest(request)
                            }
                        } : nil
                    )
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "doc.text")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(ColorPalette.textTertiary)
            
            Text("No requests yet")
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
            
            Text("Tap the buttons above to create a request")
                .font(AppTypography.captionMedium)
                .foregroundColor(ColorPalette.textTertiary)
                .multilineTextAlignment(.center)
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
    NavigationStack {
        EmployeeRequestsView()
            .environmentObject(AuthenticationViewModel())
    }
}
