//
//  AdminDashboardViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Admin Dashboard View Model
// Handles fetching and managing attendance data for all employees

@MainActor
class AdminDashboardViewModel: ObservableObject {
    @Published var employeeAttendances: [EmployeeAttendance] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    // Computed statistics
    var totalEmployees: Int {
        employeeAttendances.count
    }
    
    var presentCount: Int {
        employeeAttendances.filter { $0.isPresent }.count
    }
    
    var absentCount: Int {
        employeeAttendances.filter { !$0.isPresent && $0.attendance == nil }.count
    }
    
    var checkedOutCount: Int {
        employeeAttendances.filter { $0.attendance?.isCheckedOut == true }.count
    }
    
    var lateArrivals: Int {
        employeeAttendances.filter {
            $0.attendance?.status == .late || $0.attendance?.status == .slightlyLate
        }.count
    }
    
    var attendanceRate: Double {
        guard totalEmployees > 0 else { return 0 }
        return Double(presentCount + checkedOutCount) / Double(totalEmployees) * 100
    }
    
    // Filtered employees based on search
    var filteredEmployees: [EmployeeAttendance] {
        if searchText.isEmpty {
            return employeeAttendances
        } else {
            return employeeAttendances.filter {
                $0.employee.name.localizedCaseInsensitiveContains(searchText) ||
                $0.employee.department?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    // MARK: - Fetch Attendance Data
    func fetchAttendanceData() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Use mock data (in production, fetch from API)
        employeeAttendances = EmployeeAttendance.mockData
        
        isLoading = false
    }
    
    // MARK: - Refresh
    func refresh() async {
        await fetchAttendanceData()
        HapticManager.impact(style: .light)
    }
}
