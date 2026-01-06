//
//  User.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation

// MARK: - User Model
// Represents a user (employee or admin) in the system

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String
    let role: UserRole
    let department: String?
    let profileImageURL: String?
    
    // For preview/testing
    static let mock = User(
        id: "1",
        email: "mashaal@testsolz.com",
        name: "Mashaal Khan",
        role: .employee,
        department: "Engineering",
        profileImageURL: nil
    )
    
    static let mockAdmin = User(
        id: "2",
        email: "admin@testsolz.com",
        name: "Admin User",
        role: .admin,
        department: "HR",
        profileImageURL: nil
    )
}
