//
//  EmployeeHomeViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Employee Home View Model
// Handles fetching and displaying today's attendance status

@MainActor
class EmployeeHomeViewModel: ObservableObject {
    @Published var todayAttendance: Attendance?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Fetch Today's Status
    func fetchTodayStatus() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Mock data - in production, fetch from API
        // Simulate a checked-in employee for demo purposes
        let mockAttendance = Attendance(
            id: UUID().uuidString,
            userId: "demo-user",
            checkInTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
            checkOutTime: nil,
            date: Date()
        )
        
        todayAttendance = mockAttendance
        isLoading = false
    }
    
    // MARK: - Refresh Status
    func refreshStatus() async {
        await fetchTodayStatus()
    }
}
