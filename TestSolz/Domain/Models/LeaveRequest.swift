//
//  LeaveRequest.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Request Type
enum RequestType: String, Codable {
    case leave = "leave"
    case lateArrival = "late_arrival"
    
    var displayName: String {
        switch self {
        case .leave: return "Leave"
        case .lateArrival: return "Late Arrival"
        }
    }
    
    var icon: String {
        switch self {
        case .leave: return "calendar.badge.clock"
        case .lateArrival: return "clock.badge.exclamationmark"
        }
    }
}

// MARK: - Leave Type
enum LeaveType: String, Codable, CaseIterable {
    case sick = "sick"
    case vacation = "vacation"
    case personal = "personal"
    case emergency = "emergency"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .sick: return ColorPalette.error
        case .vacation: return ColorPalette.info
        case .personal: return ColorPalette.warning
        case .emergency: return ColorPalette.error
        }
    }
}

// MARK: - Request Status
enum RequestStatus: String, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .pending: return ColorPalette.warning
        case .approved: return ColorPalette.success
        case .rejected: return ColorPalette.error
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .approved: return "checkmark.circle.fill"
        case .rejected: return "xmark.circle.fill"
        }
    }
}

// MARK: - Leave Request Model
struct LeaveRequest: Identifiable, Codable {
    let id: String
    let userId: String
    let userName: String
    let userDepartment: String?
    let type: RequestType
    let leaveType: LeaveType? // Only for leave requests
    let startDate: Date
    let endDate: Date? // Only for leave requests
    let expectedTime: String? // Only for late arrival (e.g., "10:30 AM")
    let reason: String
    var status: RequestStatus
    var adminComment: String?
    let createdAt: Date
    var reviewedAt: Date?
    var reviewedBy: String?
    
    // Computed properties
    var daysCount: Int? {
        guard let endDate = endDate else { return nil }
        return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1
    }
    
    var formattedDateRange: String {
        if let endDate = endDate {
            return "\(startDate.formatted(style: "date")) - \(endDate.formatted(style: "date"))"
        } else {
            return startDate.formatted(style: "date")
        }
    }
    
    // Mock data
    static let mockLeave = LeaveRequest(
        id: "1",
        userId: "1",
        userName: "John Doe",
        userDepartment: "Engineering",
        type: .leave,
        leaveType: .vacation,
        startDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
        endDate: Calendar.current.date(byAdding: .day, value: 9, to: Date())!,
        expectedTime: nil,
        reason: "Family vacation",
        status: .pending,
        adminComment: nil,
        createdAt: Date(),
        reviewedAt: nil,
        reviewedBy: nil
    )
    
    static let mockLate = LeaveRequest(
        id: "2",
        userId: "1",
        userName: "John Doe",
        userDepartment: "Engineering",
        type: .lateArrival,
        leaveType: nil,
        startDate: Date(),
        endDate: nil,
        expectedTime: "10:30 AM",
        reason: "Doctor's appointment",
        status: .pending,
        adminComment: nil,
        createdAt: Date(),
        reviewedAt: nil,
        reviewedBy: nil
    )
    
    static let mockRequests = [
        LeaveRequest(id: "1", userId: "2", userName: "Sarah Wilson", userDepartment: "Design", type: .leave, leaveType: .sick, startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, expectedTime: nil, reason: "Flu", status: .pending, adminComment: nil, createdAt: Date(), reviewedAt: nil, reviewedBy: nil),
        LeaveRequest(id: "2", userId: "3", userName: "Mike Johnson", userDepartment: "Marketing", type: .lateArrival, leaveType: nil, startDate: Date(), endDate: nil, expectedTime: "11:00 AM", reason: "Car trouble", status: .pending, adminComment: nil, createdAt: Date(), reviewedAt: nil, reviewedBy: nil),
        LeaveRequest(id: "3", userId: "4", userName: "Jane Smith", userDepartment: "Engineering", type: .leave, leaveType: .vacation, startDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, endDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, expectedTime: nil, reason: "Beach trip", status: .approved, adminComment: "Enjoy!", createdAt: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, reviewedAt: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, reviewedBy: "Admin"),
    ]
}
