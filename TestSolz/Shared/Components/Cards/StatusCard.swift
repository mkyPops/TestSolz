//
//  StatusCard.swift
//  TestSolz
//
//  Created by Mashaal Khan on 26/12/2025.
//

import SwiftUI

// MARK: - Status Card
// Card for displaying attendance status (Checked In, Checked Out, etc.)
// Shows icon, status text, and timestamp

struct StatusCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let statusColor: Color
    let backgroundColor: Color
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        statusColor: Color = ColorPalette.success,
        backgroundColor: Color = ColorPalette.cardBackground
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.statusColor = statusColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        BaseCard(backgroundColor: backgroundColor) {
            HStack(spacing: Spacing.md) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(statusColor)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(title)
                        .font(AppTypography.titleMedium)
                        .foregroundColor(ColorPalette.textPrimary)
                    
                    Text(subtitle)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(ColorPalette.textSecondary)
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        StatusCard(
            icon: AppIcons.checkIn,
            title: "Checked In",
            subtitle: "Today at 9:15 AM",
            statusColor: ColorPalette.success
        )
        
        StatusCard(
            icon: AppIcons.checkOut,
            title: "Checked Out",
            subtitle: "Today at 6:30 PM",
            statusColor: ColorPalette.textSecondary
        )
        
        StatusCard(
            icon: AppIcons.warning,
            title: "Late Arrival",
            subtitle: "Today at 10:45 AM",
            statusColor: ColorPalette.warning
        )
        
        StatusCard(
            icon: AppIcons.error,
            title: "Missed Check-out",
            subtitle: "Yesterday",
            statusColor: ColorPalette.error
        )
    }
    .padding()
    .background(ColorPalette.backgroundSecondary)
}
