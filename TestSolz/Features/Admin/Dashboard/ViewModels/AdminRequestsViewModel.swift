//
//  AdminRequestsViewModel.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import Foundation
import SwiftUI

// MARK: - Admin Requests View Model
// Manages leave and late requests for admin approval

@MainActor
class AdminRequestsViewModel: ObservableObject {
    @Published var requests: [LeaveRequest] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    // Filtered requests
    var pendingRequests: [LeaveRequest] {
        let filtered = requests.filter { $0.status == .pending }
        return searchText.isEmpty ? filtered : filtered.filter {
            $0.userName.localizedCaseInsensitiveContains(searchText) ||
            $0.userDepartment?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    var approvedRequests: [LeaveRequest] {
        let filtered = requests.filter { $0.status == .approved }
        return searchText.isEmpty ? filtered : filtered.filter {
            $0.userName.localizedCaseInsensitiveContains(searchText) ||
            $0.userDepartment?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    var rejectedRequests: [LeaveRequest] {
        let filtered = requests.filter { $0.status == .rejected }
        return searchText.isEmpty ? filtered : filtered.filter {
            $0.userName.localizedCaseInsensitiveContains(searchText) ||
            $0.userDepartment?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    // Counts
    var pendingCount: Int { pendingRequests.count }
    var approvedCount: Int { approvedRequests.count }
    var rejectedCount: Int { rejectedRequests.count }
    
    // MARK: - Fetch Requests
    func fetchRequests() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock data - in production, fetch from API
        requests = LeaveRequest.mockRequests
        
        isLoading = false
    }
    
    // MARK: - Approve Request
    func approveRequest(_ request: LeaveRequest, comment: String?) async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        if let index = requests.firstIndex(where: { $0.id == request.id }) {
            var updatedRequest = requests[index]
            updatedRequest.status = .approved
            updatedRequest.adminComment = comment
            updatedRequest.reviewedAt = Date()
            updatedRequest.reviewedBy = "Admin User"
            requests[index] = updatedRequest
            
            HapticManager.notification(type: .success)
        }
        
        isLoading = false
    }
    
    // MARK: - Reject Request
    func rejectRequest(_ request: LeaveRequest, comment: String?) async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        if let index = requests.firstIndex(where: { $0.id == request.id }) {
            var updatedRequest = requests[index]
            updatedRequest.status = .rejected
            updatedRequest.adminComment = comment
            updatedRequest.reviewedAt = Date()
            updatedRequest.reviewedBy = "Admin User"
            requests[index] = updatedRequest
            
            HapticManager.notification(type: .warning)
        }
        
        isLoading = false
    }
}
