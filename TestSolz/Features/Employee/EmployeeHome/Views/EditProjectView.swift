//
//  EditProjectView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Edit Project View
// Bottom sheet for editing project name

struct EditProjectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var projectName: String
    let onSave: () -> Void
    
    var isValid: Bool {
        !projectName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                VStack(spacing: Spacing.lg) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Project Name")
                            .font(AppTypography.labelSmall)
                            .foregroundColor(ColorPalette.textSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        CustomTextField(
                            placeholder: "Enter project name",
                            text: $projectName,
                            icon: AppIcons.folder
                        )
                    }
                    
                    Spacer()
                }
                .padding(Spacing.screenHorizontal)
                .padding(.top, Spacing.md)
            }
            .navigationTitle("Edit Project")
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
                    Button("Save") {
                        onSave()
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
    EditProjectView(
        projectName: .constant("Mobile App Redesign"),
        onSave: {}
    )
}
