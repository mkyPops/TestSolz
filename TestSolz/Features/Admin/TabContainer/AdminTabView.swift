//
//  AdminTabView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Admin Tab View
// Main tab container for admin screens

struct AdminTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var selectedTab: AppTab = .dashboard
    
    var body: some View {
        ZStack {
            // Content based on selected tab
            Group {
                switch selectedTab {
                case .dashboard:
                    NavigationStack {
                        AdminDashboardView()
                    }
                case .employees:
                    EmployeeListView()
                case .adminRequests:
                    AdminRequestsView()
                default:
                    EmptyView()
                }
            }
            
            // Tab bar at bottom
            VStack {
                Spacer()
                CustomTabBar(
                    tabs: AppTab.adminTabs,
                    selectedTab: $selectedTab
                )
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

// MARK: - Preview
#Preview {
    AdminTabView()
        .environmentObject(AuthenticationViewModel())
}
