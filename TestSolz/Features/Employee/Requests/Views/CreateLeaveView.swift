//
//  CreateLeaveView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Create Leave View
// Form for requesting leave

struct CreateLeaveView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var leaveType: LeaveType
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var reason: String
    let onCreate: () -> Void
    
    var isValid: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty && startDate <= endDate
    }
    
    var daysCount: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Leave Type
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Leave Type")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            VStack(spacing: Spacing.xs) {
                                ForEach(LeaveType.allCases, id: \.self) { type in
                                    leaveTypeButton(type)
                                }
                            }
                        }
                        
                        // Dates - Compact Style
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("Dates")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            BaseCard(padding: Spacing.md) {
                                VStack(spacing: Spacing.md) {
                                    // Start Date
                                    HStack {
                                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                                            Text("Start Date")
                                                .font(AppTypography.captionMedium)
                                                .foregroundColor(ColorPalette.textSecondary)
                                            
                                            Text(startDate.formatted(style: "date"))
                                                .font(AppTypography.bodyMedium)
                                                .foregroundColor(ColorPalette.textPrimary)
                                        }
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $startDate, displayedComponents: .date)
                                            .labelsHidden()
                                            .accentColor(ColorPalette.primary)
                                    }
                                    
                                    Divider()
                                        .background(ColorPalette.divider)
                                    
                                    // End Date
                                    HStack {
                                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                                            Text("End Date")
                                                .font(AppTypography.captionMedium)
                                                .foregroundColor(ColorPalette.textSecondary)
                                            
                                            Text(endDate.formatted(style: "date"))
                                                .font(AppTypography.bodyMedium)
                                                .foregroundColor(ColorPalette.textPrimary)
                                        }
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                                            .labelsHidden()
                                            .accentColor(ColorPalette.primary)
                                    }
                                    
                                    Divider()
                                        .background(ColorPalette.divider)
                                    
                                    // Duration
                                    HStack {
                                        Image(systemName: AppIcons.clock)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(ColorPalette.primary)
                                        
                                        Text("Duration:")
                                            .font(AppTypography.bodyMedium)
                                            .foregroundColor(ColorPalette.textSecondary)
                                        
                                        Text("\(daysCount) day\(daysCount == 1 ? "" : "s")")
                                            .font(AppTypography.bodyMedium)
                                            .foregroundColor(ColorPalette.primary)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        // Reason
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Reason")
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
                                
                                TextEditor(text: $reason)
                                    .font(AppTypography.bodyMedium)
                                    .foregroundColor(ColorPalette.textPrimary)
                                    .padding(Spacing.xs)
                                    .frame(height: 100)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                
                                if reason.isEmpty {
                                    Text("Explain why you need leave...")
                                        .font(AppTypography.bodyMedium)
                                        .foregroundColor(ColorPalette.textTertiary)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.sm + 4)
                                        .allowsHitTesting(false)
                                }
                            }
                            .frame(height: 100)
                        }
                        
                        Spacer()
                    }
                    .padding(Spacing.screenHorizontal)
                    .padding(.top, Spacing.md)
                }
            }
            .navigationTitle("Request Leave")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ColorPalette.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        onCreate()
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func leaveTypeButton(_ type: LeaveType) -> some View {
        Button(action: {
            leaveType = type
            HapticManager.selection()
        }) {
            HStack {
                HStack(spacing: Spacing.sm) {
                    Circle()
                        .fill(type.color)
                        .frame(width: 8, height: 8)
                    
                    Text(type.displayName)
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(ColorPalette.textPrimary)
                }
                
                Spacer()
                
                if leaveType == type {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorPalette.primary)
                }
            }
            .padding(Spacing.md)
            .background(leaveType == type ? ColorPalette.primaryLight : ColorPalette.cardBackground)
            .cornerRadius(Radius.button)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.button)
                    .stroke(leaveType == type ? ColorPalette.primary : ColorPalette.border, lineWidth: leaveType == type ? 2 : 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    CreateLeaveView(
        leaveType: .constant(.vacation),
        startDate: .constant(Date()),
        endDate: .constant(Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        reason: .constant(""),
        onCreate: {}
    )
}
