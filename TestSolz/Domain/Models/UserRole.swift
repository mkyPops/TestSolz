//
//  UserRole.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation

// MARK: - User Role
// Defines the two types of users in the system
// Employee: Can check in/out, view own attendance
// Admin: Can view all attendance, manage users, see dashboard

enum UserRole: String, Codable {
    case employee = "employee"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .employee:
            return "Employee"
        case .admin:
            return "HR/Admin"
        }
    }
}
