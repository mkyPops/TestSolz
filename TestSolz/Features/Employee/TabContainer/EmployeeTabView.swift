//
//  EmployeeTabView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Employee Tab View
// Main tab container for employee screens

struct EmployeeTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        ZStack {
            ColorPalette.background
                .ignoresSafeArea()
            
            // Content based on selected tab
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        NavigationStack {
                            EmployeeHomeView()
                        }
                    case .history:
                        NavigationStack {
                            AttendanceHistoryView()
                        }
                    case .requests:
                        NavigationStack {
                            EmployeeRequestsView()
                        }
                    default:
                        EmptyView()
                    }
                }
                
                // Tab bar
                CustomTabBar(
                    tabs: AppTab.employeeTabs,
                    selectedTab: $selectedTab
                )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    EmployeeTabView()
        .environmentObject(AuthenticationViewModel())
}
