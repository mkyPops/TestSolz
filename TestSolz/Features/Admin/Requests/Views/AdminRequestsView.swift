//
//  AdminRequestsView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Admin Requests View
// Admin can approve/reject leave and late requests

struct AdminRequestsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                VStack {
                    Text("Admin Requests")
                        .font(AppTypography.headlineLarge)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Text("Coming soon...")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(ColorPalette.textSecondary)
                }
            }
            .navigationTitle("Requests")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    AdminRequestsView()
}
