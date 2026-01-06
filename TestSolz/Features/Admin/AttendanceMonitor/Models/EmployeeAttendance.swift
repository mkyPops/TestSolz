//
//  EmployeeAttendance.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Employee Attendance
// Represents an employee's attendance data for admin view

struct EmployeeAttendance: Identifiable {
    let id: String
    let employee: User
    let attendance: Attendance?
    
    var isPresent: Bool {
        attendance != nil && attendance?.checkOutTime == nil
    }
    
    var statusText: String {
        if let attendance = attendance {
            if attendance.isCheckedOut {
                return "Checked out"
            } else {
                return "Present"
            }
        } else {
            return "Absent"
        }
    }
    
    var statusColor: Color {
        if let attendance = attendance {
            if attendance.isCheckedOut {
                return ColorPalette.textSecondary
            } else {
                return ColorPalette.success
            }
        } else {
            return ColorPalette.textTertiary
        }
    }
    
    var checkInTimeText: String {
        if let attendance = attendance {
            return attendance.checkInTime.formatted(style: "time")
        } else {
            return "--"
        }
    }
    
    // Mock data for preview
    static let mockData: [EmployeeAttendance] = [
        EmployeeAttendance(
            id: "1",
            employee: User(id: "1", email: "john@testsolz.com", name: "John Doe", role: .employee, department: "Engineering", profileImageURL: nil),
            attendance: Attendance(id: "1", userId: "1", checkInTime: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!, checkOutTime: nil, date: Date())
        ),
        EmployeeAttendance(
            id: "2",
            employee: User(id: "2", email: "jane@testsolz.com", name: "Jane Smith", role: .employee, department: "Design", profileImageURL: nil),
            attendance: Attendance(id: "2", userId: "2", checkInTime: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!, checkOutTime: nil, date: Date())
        ),
        EmployeeAttendance(
            id: "3",
            employee: User(id: "3", email: "mike@testsolz.com", name: "Mike Johnson", role: .employee, department: "Marketing", profileImageURL: nil),
            attendance: nil
        ),
        EmployeeAttendance(
            id: "4",
            employee: User(id: "4", email: "sarah@testsolz.com", name: "Sarah Williams", role: .employee, department: "Engineering", profileImageURL: nil),
            attendance: Attendance(id: "4", userId: "4", checkInTime: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!, checkOutTime: Date(), date: Date())
        ),
    ]
}
