//
//  TaskCard.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Task Card
// Displays individual task item with menu options

struct TaskCard: View {
    let task: TaskItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    @State private var showMenu = false
    
    var body: some View {
        BaseCard(padding: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                // Task info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(task.title)
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(task.isCompleted ? ColorPalette.textTertiary : ColorPalette.textPrimary)
                        .strikethrough(task.isCompleted)
                    
                    if let description = task.description {
                        Text(description)
                            .font(AppTypography.captionMedium)
                            .foregroundColor(ColorPalette.textSecondary)
                            .lineLimit(2)
                    }
                    
                    // Priority badge
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 6, height: 6)
                        
                        Text(task.priority.displayName)
                            .font(AppTypography.captionSmall)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                }
                
                Spacer()
                
                // Three dots menu
                Menu {
                    Button(action: onToggle) {
                        Label(
                            task.isCompleted ? "Mark as Pending" : "Mark as Complete",
                            systemImage: task.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle"
                        )
                    }
                    
                    Divider()
                    
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorPalette.textSecondary)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        TaskCard(
            task: TaskItem.mock,
            onToggle: {},
            onDelete: {}
        )
        
        TaskCard(
            task: TaskItem(
                id: "2",
                userId: "1",
                projectId: "1",
                title: "Completed task example",
                description: "This task is done",
                isCompleted: true,
                createdAt: Date(),
                completedAt: Date(),
                priority: .low
            ),
            onToggle: {},
            onDelete: {}
        )
    }
    .padding()
}
