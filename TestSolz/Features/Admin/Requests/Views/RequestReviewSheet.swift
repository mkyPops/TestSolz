//
//  RequestReviewSheet.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Request Review Sheet
// Admin can approve or reject a request with optional comment

struct RequestReviewSheet: View {
    @Environment(\.dismiss) var dismiss
    let request: LeaveRequest
    let onApprove: (String?) -> Void
    let onReject: (String?) -> Void
    
    @State private var comment: String = ""
    @State private var showApproveConfirm = false
    @State private var showRejectConfirm = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Employee Info
                        employeeInfoSection
                        
                        // Request Details
                        requestDetailsSection
                        
                        // Admin Comment
                        commentSection
                        
                        // Action Buttons
                        actionButtons
                        
                        Spacer()
                    }
                    .padding(Spacing.screenHorizontal)
                    .padding(.top, Spacing.md)
                }
            }
            .navigationTitle("Review Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ColorPalette.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Approve Request", isPresented: $showApproveConfirm) {
                Button("Cancel", role: .cancel) { }
                Button("Approve", role: .none) {
                    onApprove(comment.isEmpty ? nil : comment)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to approve this request?")
            }
            .alert("Reject Request", isPresented: $showRejectConfirm) {
                Button("Cancel", role: .cancel) { }
                Button("Reject", role: .destructive) {
                    onReject(comment.isEmpty ? nil : comment)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to reject this request?")
            }
        }
    }
    
    // MARK: - Employee Info Section
    private var employeeInfoSection: some View {
        BaseCard {
            HStack(spacing: Spacing.md) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(ColorPalette.primaryLight)
                        .frame(width: 56, height: 56)
                    
                    Text(String(request.userName.prefix(1)))
                        .font(AppTypography.titleLarge)
                        .foregroundColor(ColorPalette.primary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(request.userName)
                        .font(AppTypography.titleMedium)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    if let dept = request.userDepartment {
                        Text(dept)
                            .font(AppTypography.bodySmall)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Request Details Section
    private var requestDetailsSection: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack {
                    Text("Request Details")
                        .font(AppTypography.titleSmall)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: request.type.icon)
                            .font(.system(size: 14, weight: .semibold))
                        Text(request.type.displayName)
                            .font(AppTypography.labelSmall)
                    }
                    .foregroundColor(ColorPalette.primary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xxs)
                    .background(ColorPalette.primaryLight)
                    .cornerRadius(Radius.xs)
                }
                
                Divider()
                    .background(ColorPalette.divider)
                
                // Leave Type (if applicable)
                if let leaveType = request.leaveType {
                    detailRow(
                        icon: "tag.fill",
                        label: "Type",
                        value: leaveType.displayName,
                        valueColor: leaveType.color
                    )
                }
                
                // Dates
                detailRow(
                    icon: AppIcons.calendar,
                    label: "Dates",
                    value: request.formattedDateRange,
                    valueColor: ColorPalette.textPrimary
                )
                
                // Duration (if leave)
                if let days = request.daysCount {
                    detailRow(
                        icon: AppIcons.clock,
                        label: "Duration",
                        value: "\(days) day\(days == 1 ? "" : "s")",
                        valueColor: ColorPalette.textPrimary
                    )
                }
                
                // Expected time (if late)
                if let expectedTime = request.expectedTime {
                    detailRow(
                        icon: AppIcons.clock,
                        label: "Expected Arrival",
                        value: expectedTime,
                        valueColor: ColorPalette.textPrimary
                    )
                }
                
                // Reason
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: AppIcons.document)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(ColorPalette.textTertiary)
                            .frame(width: 20)
                        
                        Text("Reason")
                            .font(AppTypography.labelSmall)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                    
                    Text(request.reason)
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(ColorPalette.textPrimary)
                        .padding(Spacing.sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(ColorPalette.backgroundSecondary)
                        .cornerRadius(Radius.xs)
                }
                
                // Submitted date
                detailRow(
                    icon: "clock.arrow.circlepath",
                    label: "Submitted",
                    value: request.createdAt.formatted(style: "datetime"),
                    valueColor: ColorPalette.textTertiary
                )
            }
        }
    }
    
    // MARK: - Comment Section
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Admin Comment (Optional)")
                .font(AppTypography.labelSmall)
                .foregroundColor(ColorPalette.textSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Radius.input)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.input)
                            .stroke(ColorPalette.border, lineWidth: 1)
                    )
                
                TextEditor(text: $comment)
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(ColorPalette.textPrimary)
                    .padding(Spacing.xs)
                    .frame(height: 80)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                
                if comment.isEmpty {
                    Text("Add a note for the employee...")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(ColorPalette.textTertiary)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.sm + 4)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 80)
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: Spacing.sm) {
            Button(action: {
                showApproveConfirm = true
            }) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: AppIcons.success)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Approve Request")
                        .font(AppTypography.buttonMedium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(ColorPalette.success)
                .cornerRadius(Radius.button)
            }
            
            Button(action: {
                showRejectConfirm = true
            }) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: AppIcons.error)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Reject Request")
                        .font(AppTypography.buttonMedium)
                }
                .foregroundColor(ColorPalette.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(ColorPalette.errorLight)
                .cornerRadius(Radius.button)
            }
        }
    }
    
    // MARK: - Detail Row
    private func detailRow(icon: String, label: String, value: String, valueColor: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorPalette.textTertiary)
                .frame(width: 20)
            
            Text(label)
                .font(AppTypography.bodySmall)
                .foregroundColor(ColorPalette.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.bodyMedium)
                .foregroundColor(valueColor)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview
#Preview {
    RequestReviewSheet(
        request: LeaveRequest.mockLeave,
        onApprove: { _ in },
        onReject: { _ in }
    )
}
