//
//  CustomTabBar.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Custom Tab Bar
// Professional bottom tab bar for navigation

struct CustomTabBar: View {
    let tabs: [AppTab]
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.xs)
        .background(
            ColorPalette.background
                .shadow(color: ColorPalette.cardShadow, radius: 8, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private func tabButton(_ tab: AppTab) -> some View {
        Button(action: {
            selectedTab = tab
            HapticManager.selection()
        }) {
            VStack(spacing: Spacing.xxs) {
                Image(systemName: selectedTab == tab ? tab.iconFilled : tab.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(selectedTab == tab ? ColorPalette.primary : ColorPalette.textTertiary)
                
                Text(tab.title)
                    .font(AppTypography.captionSmall)
                    .foregroundColor(selectedTab == tab ? ColorPalette.primary : ColorPalette.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.xs)
            .contentShape(Rectangle())
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        Spacer()
        CustomTabBar(
            tabs: AppTab.employeeTabs,
            selectedTab: .constant(.home)
        )
    }
}
