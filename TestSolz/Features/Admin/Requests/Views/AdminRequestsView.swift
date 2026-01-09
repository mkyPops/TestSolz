//
//  AdminRequestsView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Admin Requests View
// Admin can approve/reject leave and late requests

struct AdminRequestsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = AdminRequestsViewModel()
    
    @State private var selectedTab: RequestStatus = .pending
    @State private var selectedRequest: LeaveRequest?
    @State private var showReviewSheet = false
    
    var currentRequests: [LeaveRequest] {
        switch selectedTab {
        case .pending: return viewModel.pendingRequests
        case .approved: return viewModel.approvedRequests
        case .rejected: return viewModel.rejectedRequests
        }
    }
    
    var body: some View {
        ZStack {
            ColorPalette.backgroundSecondary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, Spacing.sm)
                
                // Tab Selector
                tabSelector
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.vertical, Spacing.sm)
                
                // Requests List
                if currentRequests.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.md) {
                            ForEach(currentRequests) { request in
                                RequestCard(
                                    request: request,
                                    showEmployeeName: true,
                                    onDelete: nil
                                )
                                .onTapGesture {
                                    if request.status == .pending {
                                        selectedRequest = request
                                        showReviewSheet = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.screenHorizontal)
                        .padding(.top, Spacing.sm)
                        .padding(.bottom, 100)
                    }
                }
            }
            .refreshable {
                await viewModel.fetchRequests()
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
        .onAppear {
            if viewModel.requests.isEmpty {
                Task {
                    await viewModel.fetchRequests()
                }
            }
        }
        .sheet(isPresented: $showReviewSheet) {
            if let request = selectedRequest {
                RequestReviewSheet(
                    request: request,
                    onApprove: { comment in
                        Task {
                            await viewModel.approveRequest(request, comment: comment)
                        }
                    },
                    onReject: { comment in
                        Task {
                            await viewModel.rejectRequest(request, comment: comment)
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: AppIcons.search)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ColorPalette.textTertiary)
            
            TextField("Search by name or department...", text: $viewModel.searchText)
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
                .fill(ColorPalette.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.input)
                .stroke(ColorPalette.border, lineWidth: 1)
        )
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: Spacing.xs) {
            tabButton(.pending, count: viewModel.pendingCount)
            tabButton(.approved, count: viewModel.approvedCount)
            tabButton(.rejected, count: viewModel.rejectedCount)
        }
        .padding(Spacing.xxs)
        .background(ColorPalette.cardBackground)
        .cornerRadius(Radius.button)
    }
    
    private func tabButton(_ status: RequestStatus, count: Int) -> some View {
        Button(action: {
            selectedTab = status
            HapticManager.selection()
        }) {
            VStack(spacing: Spacing.xxs) {
                Text(status.displayName)
                    .font(AppTypography.labelSmall)
                    .foregroundColor(selectedTab == status ? .white : ColorPalette.textSecondary)
                
                Text("\(count)")
                    .font(AppTypography.captionSmall)
                    .foregroundColor(selectedTab == status ? .white : ColorPalette.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .background(selectedTab == status ? status.color : Color.clear)
            .cornerRadius(Radius.xs)
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: selectedTab == .pending ? "checkmark.circle" : "doc.text")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(ColorPalette.textTertiary)
            
            Text("No \(selectedTab.displayName.lowercased()) requests")
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
            
            if selectedTab == .pending {
                Text("You're all caught up!")
                    .font(AppTypography.captionMedium)
                    .foregroundColor(ColorPalette.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        AdminRequestsView()
            .environmentObject(AuthenticationViewModel())
    }
}
