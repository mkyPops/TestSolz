//
//  Task.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Project Model
struct Project: Identifiable, Codable {
    let id: String
    let name: String
    let description: String?
    let color: String // Hex color for the project
    
    var displayColor: Color {
        Color(hex: color)
    }
    
    // Mock data
    static let mock = Project(
        id: "1",
        name: "Mobile App Redesign",
        description: "Redesigning the company mobile application",
        color: "#00D9D9"
    )
    
    static let mockProjects = [
        Project(id: "1", name: "Mobile App Redesign", description: "Redesigning mobile app", color: "#00D9D9"),
        Project(id: "2", name: "Website Optimization", description: "SEO and performance", color: "#10B981"),
        Project(id: "3", name: "Client Dashboard", description: "New client portal", color: "#F59E0B"),
    ]
}

// MARK: - Task Model
struct TaskItem: Identifiable, Codable {
    let id: String
    let userId: String
    let projectId: String
    var title: String
    var description: String?
    var isCompleted: Bool
    let createdAt: Date
    var completedAt: Date?
    var priority: TaskPriority
    
    enum TaskPriority: String, Codable, CaseIterable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        
        var displayName: String {
            rawValue.capitalized
        }
        
        var color: Color {
            switch self {
            case .low: return ColorPalette.info
            case .medium: return ColorPalette.warning
            case .high: return ColorPalette.error
            }
        }
    }
    
    // Mock data
    static let mock = TaskItem(
        id: "1",
        userId: "1",
        projectId: "1",
        title: "Design login screen",
        description: "Create mockups for new login",
        isCompleted: false,
        createdAt: Date(),
        completedAt: nil,
        priority: .high
    )
    
    static let mockTasks = [
        TaskItem(id: "1", userId: "1", projectId: "1", title: "Design login screen", description: "Create mockups", isCompleted: false, createdAt: Date(), completedAt: nil, priority: .high),
        TaskItem(id: "2", userId: "1", projectId: "1", title: "Implement API integration", description: "Connect to backend", isCompleted: false, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, completedAt: nil, priority: .medium),
        TaskItem(id: "3", userId: "1", projectId: "1", title: "Write unit tests", description: nil, isCompleted: true, createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, completedAt: Date(), priority: .low),
    ]
}
