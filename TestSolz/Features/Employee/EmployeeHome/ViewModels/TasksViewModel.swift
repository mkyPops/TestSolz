//
//  TasksViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Tasks View Model
// Manages tasks and projects for employees

@MainActor
class TasksViewModel: ObservableObject {
    @Published var currentProject: Project?
    @Published var tasks: [TaskItem] = []
    @Published var isLoading: Bool = false
    @Published var showCreateTask: Bool = false
    
    // Task counts
    var pendingTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var activeTasks: [TaskItem] {
        tasks.filter { !$0.isCompleted }.sorted { $0.createdAt > $1.createdAt }
    }
    
    var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }.sorted { $0.completedAt ?? Date() > $1.completedAt ?? Date() }
    }
    
    // MARK: - Fetch Data
    func fetchProjectAndTasks(userId: String) async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock data - in production, fetch from API
        currentProject = Project.mock
        tasks = TaskItem.mockTasks
        
        isLoading = false
    }
    
    // MARK: - Create Task
    func createTask(title: String, description: String?, priority: TaskItem.TaskPriority, userId: String) async {
        guard let projectId = currentProject?.id else { return }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let newTask = TaskItem(
            id: UUID().uuidString,
            userId: userId,
            projectId: projectId,
            title: title,
            description: description,
            isCompleted: false,
            createdAt: Date(),
            completedAt: nil,
            priority: priority
        )
        
        tasks.insert(newTask, at: 0)
        HapticManager.notification(type: .success)
        
        isLoading = false
    }
    
    // MARK: - Toggle Task Completion
    func toggleTaskCompletion(_ task: TaskItem) async {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        tasks[index].isCompleted.toggle()
        tasks[index].completedAt = tasks[index].isCompleted ? Date() : nil
        
        HapticManager.impact(style: .light)
    }
    
    // MARK: - Delete Task
    func deleteTask(_ task: TaskItem) async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        tasks.removeAll { $0.id == task.id }
        HapticManager.impact(style: .light)
    }
    
    // MARK: - Update Project Name
    func updateProjectName(_ newName: String) async {
        guard var project = currentProject else { return }
        
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        project = Project(
            id: project.id,
            name: newName,
            description: project.description,
            color: project.color
        )
        
        currentProject = project
        HapticManager.notification(type: .success)
        
        isLoading = false
    }
    
}

