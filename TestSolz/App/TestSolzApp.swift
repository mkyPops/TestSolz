//
//  TestSolzApp.swift
//  TestSolz
//
//  Created by Mashaal Khan on 23/12/2025.
//

import SwiftUI

@main
struct TestSolzApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                // User is logged in - show main app based on role
                if authViewModel.currentUser?.role == .admin {
                    AdminTabView()
                        .environmentObject(authViewModel)
                } else {
                    EmployeeTabView()
                        .environmentObject(authViewModel)
                }
            } else {
                // User not logged in - show login screen
                AuthenticationView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
