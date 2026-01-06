//
//  AttendanceHistoryViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Attendance History View Model
// Manages attendance history data and filtering

@MainActor
class AttendanceHistoryViewModel: ObservableObject {
    @Published var attendanceRecords: [Attendance] = []
    @Published var isLoading: Bool = false
    @Published var selectedMonth: Date = Date()
    @Published var selectedDate: Date?
    
    // Computed properties
    var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    var daysInMonth: [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: selectedMonth) else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            var components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
            components.day = day
            return Calendar.current.date(from: components)
        }
    }
    
    var selectedDateAttendance: Attendance? {
        guard let selectedDate = selectedDate else { return nil }
        return attendanceRecords.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    // Statistics
    var totalDaysPresent: Int {
        attendanceRecords.filter { Calendar.current.isDate($0.date, equalTo: selectedMonth, toGranularity: .month) }.count
    }
    
    var totalDaysLate: Int {
        attendanceRecords.filter {
            Calendar.current.isDate($0.date, equalTo: selectedMonth, toGranularity: .month) &&
            ($0.status == .late || $0.status == .slightlyLate)
        }.count
    }
    
    var averageHours: Double {
        let records = attendanceRecords.filter {
            Calendar.current.isDate($0.date, equalTo: selectedMonth, toGranularity: .month) &&
            $0.hoursWorked != nil
        }
        
        guard !records.isEmpty else { return 0 }
        
        let totalHours = records.compactMap { $0.hoursWorked }.reduce(0, +)
        return totalHours / Double(records.count)
    }
    
    var attendanceRate: Double {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: selectedMonth) else { return 0 }
        
        let totalWorkDays = range.count
        let presentDays = totalDaysPresent
        
        guard totalWorkDays > 0 else { return 0 }
        return Double(presentDays) / Double(totalWorkDays) * 100
    }
    
    // MARK: - Fetch History
    func fetchHistory(userId: String) async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Use mock data (replace with real API call in production)
        attendanceRecords = Attendance.mockHistory(userId: userId, daysBack: 90)
        
        isLoading = false
    }
    
    // MARK: - Month Navigation
    func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newDate
            HapticManager.selection()
        }
    }
    
    func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newDate
            HapticManager.selection()
        }
    }
    
    // MARK: - Get Status for Date
    func getStatusForDate(_ date: Date) -> AttendanceStatus? {
        guard let attendance = attendanceRecords.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }) else {
            return nil
        }
        return attendance.status
    }
    
    func hasAttendanceForDate(_ date: Date) -> Bool {
        attendanceRecords.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
