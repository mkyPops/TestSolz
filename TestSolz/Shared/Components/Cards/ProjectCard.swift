//
//  ProjectCard.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Project Card
// Displays current project information with edit option

struct ProjectCard: View {
    let project: Project
    let pendingTasks: Int
    let completedTasks: Int
    let onEdit: () -> Void
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                // Header
                HStack(spacing: Spacing.sm) {
                    // Project color indicator
                    RoundedRectangle(cornerRadius: 4)
                        .fill(project.displayColor)
                        .frame(width: 4, height: 40)
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Current Project")
                            .font(AppTypography.captionMedium)
                            .foregroundColor(ColorPalette.textSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        Text(project.name)
                            .font(AppTypography.titleMedium)
                            .foregroundColor(ColorPalette.textPrimary)
                    }
                    
                    Spacer()
                    
                    // Edit button
                    Button(action: onEdit) {
                        Image(systemName: AppIcons.edit)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                }
                
                // Description
                if let description = project.description {
                    Text(description)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(ColorPalette.textSecondary)
                        .lineLimit(2)
                }
                
                Divider()
                    .background(ColorPalette.divider)
                
                // Task stats
                HStack(spacing: Spacing.lg) {
                    taskStat(
                        icon: AppIcons.clock,
                        label: "Pending",
                        value: "\(pendingTasks)",
                        color: ColorPalette.warning
                    )
                    
                    taskStat(
                        icon: AppIcons.success,
                        label: "Completed",
                        value: "\(completedTasks)",
                        color: ColorPalette.success
                    )
                }
            }
        }
    }
    
    private func taskStat(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(AppTypography.titleSmall)
                    .foregroundColor(ColorPalette.textPrimary)
                
                Text(label)
                    .font(AppTypography.captionSmall)
                    .foregroundColor(ColorPalette.textSecondary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProjectCard(
        project: Project.mock,
        pendingTasks: 5,
        completedTasks: 12,
        onEdit: {}
    )
    .padding()
}
