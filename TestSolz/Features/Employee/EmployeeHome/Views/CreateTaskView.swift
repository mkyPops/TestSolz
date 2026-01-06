//
//  CreateTaskView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Create Task View
// Bottom sheet for creating new tasks

struct CreateTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var title: String
    @Binding var description: String
    @Binding var priority: TaskItem.TaskPriority
    let onCreate: () -> Void
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Title field
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Task Title")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            CustomTextField(
                                placeholder: "Enter task title",
                                text: $title,
                                icon: AppIcons.document
                            )
                        }
                        
                        // Description field
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Description (Optional)")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            ZStack(alignment: .topLeading) {
                                // Background and border
                                RoundedRectangle(cornerRadius: Radius.input)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Radius.input)
                                            .stroke(ColorPalette.border, lineWidth: 1)
                                    )
                                
                                // TextEditor
                                TextEditor(text: $description)
                                    .font(AppTypography.bodyMedium)
                                    .foregroundColor(ColorPalette.textPrimary)
                                    .padding(Spacing.xs)
                                    .frame(height: 100)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                
                                // Placeholder
                                if description.isEmpty {
                                    Text("Enter task description...")
                                        .font(AppTypography.bodyMedium)
                                        .foregroundColor(ColorPalette.textTertiary)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.sm + 4)
                                        .allowsHitTesting(false)
                                }
                            }
                            .frame(height: 100)
                        }
                        
                        // Priority selector
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Priority")
                                .font(AppTypography.labelSmall)
                                .foregroundColor(ColorPalette.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            HStack(spacing: Spacing.sm) {
                                ForEach(TaskItem.TaskPriority.allCases, id: \.self) { priorityOption in
                                    priorityButton(priorityOption)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(Spacing.screenHorizontal)
                    .padding(.top, Spacing.md)
                }
            }
            .navigationTitle("Create Task")
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
                    Button("Create") {
                        onCreate()
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    // MARK: - Priority Button
    private func priorityButton(_ priorityOption: TaskItem.TaskPriority) -> some View {
        Button(action: {
            priority = priorityOption
            HapticManager.selection()
        }) {
            HStack(spacing: Spacing.xs) {
                Circle()
                    .fill(priorityOption.color)
                    .frame(width: 8, height: 8)
                
                Text(priorityOption.displayName)
                    .font(AppTypography.labelSmall)
            }
            .foregroundColor(priority == priorityOption ? ColorPalette.textPrimary : ColorPalette.textSecondary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(priority == priorityOption ? priorityOption.color.opacity(0.15) : ColorPalette.cardBackground)
            .cornerRadius(Radius.button)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.button)
                    .stroke(priority == priorityOption ? priorityOption.color : ColorPalette.border, lineWidth: priority == priorityOption ? 2 : 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    CreateTaskView(
        title: .constant(""),
        description: .constant(""),
        priority: .constant(.medium),
        onCreate: {}
    )
}
