//
//  RequestsViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Requests View Model
// Manages leave and late arrival requests for employees

@MainActor
class RequestsViewModel: ObservableObject {
    @Published var requests: [LeaveRequest] = []
    @Published var isLoading: Bool = false
    @Published var showCreateLeave: Bool = false
    @Published var showCreateLate: Bool = false
    @Published var errorMessage: String?
    
    // Filtered requests
    var pendingRequests: [LeaveRequest] {
        requests.filter { $0.status == .pending }.sorted { $0.createdAt > $1.createdAt }
    }
    
    var approvedRequests: [LeaveRequest] {
        requests.filter { $0.status == .approved }.sorted { $0.reviewedAt ?? Date() > $1.reviewedAt ?? Date() }
    }
    
    var rejectedRequests: [LeaveRequest] {
        requests.filter { $0.status == .rejected }.sorted { $0.reviewedAt ?? Date() > $1.reviewedAt ?? Date() }
    }
    
    // Counts
    var pendingCount: Int { pendingRequests.count }
    var approvedCount: Int { approvedRequests.count }
    var rejectedCount: Int { rejectedRequests.count }
    
    // MARK: - Fetch Requests
    func fetchRequests(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock data - in production, fetch from API
        requests = [
            LeaveRequest(
                id: "1",
                userId: userId,
                userName: "Current User",
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
            ),
            LeaveRequest(
                id: "2",
                userId: userId,
                userName: "Current User",
                userDepartment: "Engineering",
                type: .lateArrival,
                leaveType: nil,
                startDate: Date(),
                endDate: nil,
                expectedTime: "10:30 AM",
                reason: "Doctor's appointment",
                status: .pending,
                adminComment: nil,
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
                reviewedAt: nil,
                reviewedBy: nil
            ),
            LeaveRequest(
                id: "3",
                userId: userId,
                userName: "Current User",
                userDepartment: "Engineering",
                type: .leave,
                leaveType: .sick,
                startDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                expectedTime: nil,
                reason: "Flu",
                status: .approved,
                adminComment: "Get well soon!",
                createdAt: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
                reviewedAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                reviewedBy: "Admin User"
            ),
        ]
        
        isLoading = false
    }
    
    // MARK: - Create Leave Request
    func createLeaveRequest(
        userId: String,
        userName: String,
        userDepartment: String?,
        leaveType: LeaveType,
        startDate: Date,
        endDate: Date,
        reason: String
    ) async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newRequest = LeaveRequest(
            id: UUID().uuidString,
            userId: userId,
            userName: userName,
            userDepartment: userDepartment,
            type: .leave,
            leaveType: leaveType,
            startDate: startDate,
            endDate: endDate,
            expectedTime: nil,
            reason: reason,
            status: .pending,
            adminComment: nil,
            createdAt: Date(),
            reviewedAt: nil,
            reviewedBy: nil
        )
        
        requests.insert(newRequest, at: 0)
        HapticManager.notification(type: .success)
        
        isLoading = false
    }
    
    // MARK: - Create Late Arrival Request
    func createLateRequest(
        userId: String,
        userName: String,
        userDepartment: String?,
        date: Date,
        expectedTime: String,
        reason: String
    ) async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newRequest = LeaveRequest(
            id: UUID().uuidString,
            userId: userId,
            userName: userName,
            userDepartment: userDepartment,
            type: .lateArrival,
            leaveType: nil,
            startDate: date,
            endDate: nil,
            expectedTime: expectedTime,
            reason: reason,
            status: .pending,
            adminComment: nil,
            createdAt: Date(),
            reviewedAt: nil,
            reviewedBy: nil
        )
        
        requests.insert(newRequest, at: 0)
        HapticManager.notification(type: .success)
        
        isLoading = false
    }
    
    // MARK: - Delete Request
    func deleteRequest(_ request: LeaveRequest) async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        requests.removeAll { $0.id == request.id }
        HapticManager.impact(style: .light)
    }
}
