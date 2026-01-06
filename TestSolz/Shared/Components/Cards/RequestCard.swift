//
//  RequestCard.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Request Card
// Displays leave or late arrival request

struct RequestCard: View {
    let request: LeaveRequest
    let showEmployeeName: Bool // True for admin view, false for employee view
    let onDelete: (() -> Void)?
    
    init(request: LeaveRequest, showEmployeeName: Bool = false, onDelete: (() -> Void)? = nil) {
        self.request = request
        self.showEmployeeName = showEmployeeName
        self.onDelete = onDelete
    }
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                // Header
                HStack(spacing: Spacing.sm) {
                    // Type icon
                    ZStack {
                        Circle()
                            .fill(request.type == .leave ? ColorPalette.primaryLight : ColorPalette.warningLight)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: request.type.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(request.type == .leave ? ColorPalette.primary : ColorPalette.warning)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        HStack(spacing: Spacing.xs) {
                            Text(request.type.displayName)
                                .font(AppTypography.titleSmall)
                                .foregroundColor(ColorPalette.textPrimary)
                            
                            if let leaveType = request.leaveType {
                                Text("•")
                                    .font(AppTypography.captionMedium)
                                    .foregroundColor(ColorPalette.textTertiary)
                                
                                Text(leaveType.displayName)
                                    .font(AppTypography.captionMedium)
                                    .foregroundColor(leaveType.color)
                                    .padding(.horizontal, Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(leaveType.color.opacity(0.1))
                                    .cornerRadius(Radius.xs)
                            }
                        }
                        
                        if showEmployeeName {
                            HStack(spacing: Spacing.xxs) {
                                Text(request.userName)
                                    .font(AppTypography.captionMedium)
                                    .foregroundColor(ColorPalette.textSecondary)
                                
                                if let dept = request.userDepartment {
                                    Text("•")
                                        .font(AppTypography.captionSmall)
                                        .foregroundColor(ColorPalette.textTertiary)
                                    
                                    Text(dept)
                                        .font(AppTypography.captionSmall)
                                        .foregroundColor(ColorPalette.textTertiary)
                                }
                            }
                        } else {
                            Text(request.formattedDateRange)
                                .font(AppTypography.captionMedium)
                                .foregroundColor(ColorPalette.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Status badge
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: request.status.icon)
                            .font(.system(size: 12, weight: .semibold))
                        Text(request.status.displayName)
                            .font(AppTypography.captionSmall)
                    }
                    .foregroundColor(request.status.color)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xxs)
                    .background(request.status.color.opacity(0.1))
                    .cornerRadius(Radius.sm)
                }
                
                // Details
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    if showEmployeeName {
                        detailRow(icon: AppIcons.calendar, text: request.formattedDateRange)
                    }
                    
                    if let days = request.daysCount {
                        detailRow(icon: AppIcons.clock, text: "\(days) day\(days == 1 ? "" : "s")")
                    }
                    
                    if let expectedTime = request.expectedTime {
                        detailRow(icon: AppIcons.clock, text: "Expected: \(expectedTime)")
                    }
                    
                    detailRow(icon: AppIcons.document, text: request.reason)
                }
                
                // Admin comment (if approved/rejected)
                if let comment = request.adminComment, !comment.isEmpty {
                    Divider()
                        .background(ColorPalette.divider)
                    
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: AppIcons.info)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorPalette.textTertiary)
                        
                        Text("Admin: \(comment)")
                            .font(AppTypography.captionMedium)
                            .foregroundColor(ColorPalette.textSecondary)
                            .italic()
                    }
                }
                
                // Footer (created date and delete option)
                HStack {
                    Text("Created \(request.createdAt.formatted(style: "date"))")
                        .font(AppTypography.captionSmall)
                        .foregroundColor(ColorPalette.textTertiary)
                    
                    Spacer()
                    
                    if request.status == .pending, let onDelete = onDelete {
                        Button(action: onDelete) {
                            HStack(spacing: Spacing.xxs) {
                                Image(systemName: AppIcons.delete)
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Cancel")
                                    .font(AppTypography.captionSmall)
                            }
                            .foregroundColor(ColorPalette.error)
                        }
                    }
                }
            }
        }
    }
    
    private func detailRow(icon: String, text: String) -> some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ColorPalette.textTertiary)
                .frame(width: 16)
            
            Text(text)
                .font(AppTypography.bodySmall)
                .foregroundColor(ColorPalette.textPrimary)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        RequestCard(
            request: LeaveRequest.mockLeave,
            showEmployeeName: false,
            onDelete: {}
        )
        
        RequestCard(
            request: LeaveRequest.mockLate,
            showEmployeeName: true,
            onDelete: nil
        )
    }
    .padding()
}
