//
//  CheckInViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Check In View Model
// Handles check-in/check-out logic for employees

@MainActor
class CheckInViewModel: ObservableObject {
    @Published var currentAttendance: Attendance?
    @Published var isLoading: Bool = false
    @Published var showSuccessMessage: Bool = false
    @Published var errorMessage: String?
    
    var isCheckedIn: Bool {
        currentAttendance != nil && currentAttendance?.checkOutTime == nil
    }
    
    // MARK: - Check In
    func checkIn(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Create attendance record
        let attendance = Attendance(
            id: UUID().uuidString,
            userId: userId,
            checkInTime: Date(),
            checkOutTime: nil,
            date: Date()
        )
        
        currentAttendance = attendance
        showSuccessMessage = true
        HapticManager.notification(type: .success)
        
        isLoading = false
        
        // Hide success message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSuccessMessage = false
        }
    }
    
    // MARK: - Check Out
    func checkOut() async {
        guard var attendance = currentAttendance else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Update attendance with check-out time
        attendance.checkOutTime = Date()
        currentAttendance = attendance
        showSuccessMessage = true
        HapticManager.notification(type: .success)
        
        isLoading = false
        
        // Hide success message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSuccessMessage = false
        }
    }
    
    // MARK: - Get Today's Status
    func getTodayStatus() -> String {
        guard let attendance = currentAttendance else {
            return "Not checked in yet"
        }
        
        if attendance.isCheckedOut {
            return "Checked out at \(attendance.checkOutTime!.formatted(style: "time"))"
        } else {
            return "Checked in at \(attendance.checkInTime.formatted(style: "time"))"
        }
    }
}
