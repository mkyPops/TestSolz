//
//  Attendance.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Attendance Record
// Represents a single day's attendance (check-in and check-out)

struct Attendance: Identifiable, Codable {
    let id: String
    let userId: String
    let checkInTime: Date
    var checkOutTime: Date?
    let date: Date

    // MARK: - Computed Properties

    var hoursWorked: Double? {
        guard let checkOutTime else { return nil }
        return checkOutTime.timeIntervalSince(checkInTime) / 3600
    }

    var isCheckedOut: Bool {
        checkOutTime != nil
    }

    var status: AttendanceStatus {
        let hour = Calendar.current.component(.hour, from: checkInTime)
        let minute = Calendar.current.component(.minute, from: checkInTime)
        let totalMinutes = hour * 60 + minute

        // Work start time: 9:00 AM (540 minutes)
        if totalMinutes <= 540 {
            return .onTime
        } else if totalMinutes <= 555 {
            return .slightlyLate
        } else {
            return .late
        }
    }

    // MARK: - Mock Data

    static let mock = Attendance(
        id: UUID().uuidString,
        userId: "1",
        checkInTime: Date(),
        checkOutTime: nil,
        date: Date()
    )

    static let mockCheckedOut = Attendance(
        id: UUID().uuidString,
        userId: "1",
        checkInTime: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!,
        checkOutTime: Date(),
        date: Date()
    )
}

// MARK: - Attendance Status

enum AttendanceStatus: String, Codable {
    case onTime = "on_time"
    case slightlyLate = "slightly_late"
    case late = "late"
    case absent = "absent"

    // MARK: - UI Helpers

    var displayName: String {
        switch self {
        case .onTime: return "On Time"
        case .slightlyLate: return "Slightly Late"
        case .late: return "Late"
        case .absent: return "Absent"
        }
    }

    var color: Color {
        switch self {
        case .onTime: return ColorPalette.success
        case .slightlyLate: return ColorPalette.warning
        case .late: return ColorPalette.error
        case .absent: return ColorPalette.textTertiary
        }
    }
}

// MARK: - Date Formatting

extension Date {
    func formatted(style: String = "time") -> String {
        let formatter = DateFormatter()

        switch style {
        case "time":
            formatter.dateFormat = "h:mm a"
        case "date":
            formatter.dateFormat = "MMM d, yyyy"
        case "datetime":
            formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        default:
            formatter.dateFormat = "h:mm a"
        }

        return formatter.string(from: self)
    }
}

// MARK: - Mock History Data
extension Attendance {
    static func mockHistory(userId: String, daysBack: Int = 30) -> [Attendance] {
        var history: [Attendance] = []
        let calendar = Calendar.current

        for day in 0..<daysBack {
            guard let date = calendar.date(byAdding: .day, value: -day, to: Date()) else { continue }

            // Randomly skip some days (absent)
            if Int.random(in: 0...10) > 8 { continue }

            // Random check-in time between 8:30 AM and 10:00 AM
            let checkInHour = Int.random(in: 8...9)
            let checkInMinute = Int.random(in: 0...59)
            var checkInComponents = calendar.dateComponents([.year, .month, .day], from: date)
            checkInComponents.hour = checkInHour
            checkInComponents.minute = checkInMinute

            guard let checkInTime = calendar.date(from: checkInComponents) else { continue }

            // Random check-out time between 5:00 PM and 7:00 PM
            let checkOutHour = Int.random(in: 17...19)
            let checkOutMinute = Int.random(in: 0...59)
            var checkOutComponents = calendar.dateComponents([.year, .month, .day], from: date)
            checkOutComponents.hour = checkOutHour
            checkOutComponents.minute = checkOutMinute

            let checkOutTime = calendar.date(from: checkOutComponents)

            let attendance = Attendance(
                id: UUID().uuidString,
                userId: userId,
                checkInTime: checkInTime,
                checkOutTime: checkOutTime,
                date: date
            )

            history.append(attendance)
        }

        return history.sorted { $0.date > $1.date }
    }
}
