//
//  CreateLateView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Create Late View
// Form for reporting late arrival

struct CreateLateView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var date: Date
    @Binding var time: Date
    @Binding var reason: String
    let onCreate: () -> Void
    
    var isValid: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Date
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Date")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            DatePicker("Select Date", selection: $date, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding(Spacing.md)
                                .background(ColorPalette.cardBackground)
                                .cornerRadius(Radius.card)
                        }
                        
                        // Expected Time
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Expected Arrival Time")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .padding(Spacing.md)
                                .background(ColorPalette.cardBackground)
                                .cornerRadius(Radius.card)
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
                                    Text("Explain why you'll be late...")
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
            .navigationTitle("Report Late")
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
}

// MARK: - Preview
#Preview {
    CreateLateView(
        date: .constant(Date()),
        time: .constant(Date()),
        reason: .constant(""),
        onCreate: {}
    )
}
