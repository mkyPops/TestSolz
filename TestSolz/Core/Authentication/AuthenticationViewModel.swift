//
//  AuthenticationViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Authentication View Model
// Handles login logic and authentication state
// In production, this would connect to your backend API

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    // MARK: - Login
    func login() async {
        // Validate inputs
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return
        }
        
        // Show loading
        isLoading = true
        errorMessage = nil
        
        // Simulate API call (replace with real API in production)
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Mock authentication logic
        // In production: Call your backend API here
        if email.lowercased() == "admin@testsolz.com" && password == "admin123" {
            currentUser = User.mockAdmin
            isAuthenticated = true
            HapticManager.notification(type: .success)
        } else if email.lowercased().contains("@testsolz.com") && password == "test123" {
            currentUser = User.mock
            isAuthenticated = true
            HapticManager.notification(type: .success)
        } else {
            errorMessage = "Invalid email or password"
            HapticManager.notification(type: .error)
        }
        
        isLoading = false
    }
    
    // MARK: - Logout
    func logout() {
        currentUser = nil
        isAuthenticated = false
        email = ""
        password = ""
        HapticManager.impact(style: .light)
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}
