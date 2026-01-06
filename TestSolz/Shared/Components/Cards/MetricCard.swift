//
//  MetricCard.swift
//  TestSolz
//
//  Created by Mashaal Khan on 26/12/2025.
//

import SwiftUI

// MARK: - Metric Card
// Card for displaying key metrics and statistics
// Used in admin dashboard for showing attendance stats

struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    let accentColor: Color
    let backgroundColor: Color
    
    init(
        icon: String,
        title: String,
        value: String,
        subtitle: String? = nil,
        accentColor: Color = ColorPalette.primary,
        backgroundColor: Color = ColorPalette.cardBackground
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        BaseCard(backgroundColor: backgroundColor) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                // Icon and title
                HStack(spacing: Spacing.xs) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(accentColor)
                    
                    Text(title)
                        .font(AppTypography.labelSmall)
                        .foregroundColor(ColorPalette.textSecondary)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Spacer()
                }
                
                // Value
                Text(value)
                    .font(AppTypography.displaySmall)
                    .foregroundColor(ColorPalette.textPrimary)
                    .fontWeight(.bold)
                
                // Subtitle (optional)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppTypography.captionMedium)
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        // Two-column grid
        HStack(spacing: Spacing.md) {
            MetricCard(
                icon: AppIcons.users,
                title: "Present Today",
                value: "42",
                subtitle: "Out of 50 employees",
                accentColor: ColorPalette.success
            )
            
            MetricCard(
                icon: AppIcons.clock,
                title: "Late Arrivals",
                value: "3",
                subtitle: "This week",
                accentColor: ColorPalette.warning
            )
        }
        
        HStack(spacing: Spacing.md) {
            MetricCard(
                icon: AppIcons.chart,
                title: "Avg Hours",
                value: "8.2h",
                subtitle: "Per employee",
                accentColor: ColorPalette.primary
            )
            
            MetricCard(
                icon: AppIcons.calendar,
                title: "This Month",
                value: "95%",
                subtitle: "Attendance rate",
                accentColor: ColorPalette.success
            )
        }
    }
    .padding()
    .background(ColorPalette.backgroundSecondary)
}
