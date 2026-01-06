//
//  AppTab.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - App Tab
// Defines available tabs for employee and admin

enum AppTab: String, CaseIterable {
    case home
    case history
    case requests
    
    // Employee tabs
    static var employeeTabs: [AppTab] {
        [.home, .history, .requests]
    }
    
    // Admin tabs
    case dashboard
    case employees
    case adminRequests
    
    static var adminTabs: [AppTab] {
        [.dashboard, .employees, .adminRequests]
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .history: return "History"
        case .requests: return "Requests"
        case .dashboard: return "Dashboard"
        case .employees: return "Employees"
        case .adminRequests: return "Requests"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .history: return "calendar"
        case .requests: return "doc.text"
        case .dashboard: return "chart.bar"
        case .employees: return "person.2"
        case .adminRequests: return "doc.text"
        }
    }
    
    var iconFilled: String {
        switch self {
        case .home: return "house.fill"
        case .history: return "calendar"
        case .requests: return "doc.text.fill"
        case .dashboard: return "chart.bar.fill"
        case .employees: return "person.2.fill"
        case .adminRequests: return "doc.text.fill"
        }
    }
}
