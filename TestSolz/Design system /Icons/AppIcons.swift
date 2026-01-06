//
//  AppIcons.swift
//  TestSolz
//
//  Created by Mashaal Khan on 24/12/2025.
//

import SwiftUI

// MARK: - App Icons
// Centralized icon definitions using SF Symbols (Apple's icon system)
// SF Symbols are free, professional, and work perfectly with iOS

struct AppIcons {
    
    // MARK: - Navigation Icons
    static let home = "house.fill"
    static let homeOutline = "house"
    static let profile = "person.fill"
    static let profileOutline = "person"
    static let settings = "gearshape.fill"
    static let settingsOutline = "gearshape"
    static let dashboard = "square.grid.2x2.fill"
    static let dashboardOutline = "square.grid.2x2"
    
    // MARK: - Attendance Icons
    static let checkIn = "arrow.down.circle.fill"
    static let checkOut = "arrow.up.circle.fill"
    static let clock = "clock.fill"
    static let clockOutline = "clock"
    static let calendar = "calendar"
    static let calendarFill = "calendar.circle.fill"
    static let timer = "timer"
    
    // MARK: - Status Icons
    static let success = "checkmark.circle.fill"
    static let error = "xmark.circle.fill"
    static let warning = "exclamationmark.triangle.fill"
    static let info = "info.circle.fill"
    static let present = "checkmark.seal.fill"
    static let absent = "xmark.seal.fill"
    
    // MARK: - Action Icons
    static let add = "plus.circle.fill"
    static let edit = "pencil.circle.fill"
    static let delete = "trash.fill"
    static let search = "magnifyingglass"
    static let filter = "line.3.horizontal.decrease.circle"
    static let refresh = "arrow.clockwise"
    static let share = "square.and.arrow.up"
    static let download = "arrow.down.circle"
    
    // MARK: - Navigation Actions
    static let back = "chevron.left"
    static let forward = "chevron.right"
    static let close = "xmark"
    static let menu = "line.3.horizontal"
    static let moreVertical = "ellipsis"
    static let moreHorizontal = "ellipsis"
    
    // MARK: - User & People Icons
    static let user = "person.circle.fill"
    static let userOutline = "person.circle"
    static let users = "person.2.fill"
    static let usersOutline = "person.2"
    static let team = "person.3.fill"
    
    // MARK: - Document & Data Icons
    static let document = "doc.fill"
    static let documentOutline = "doc"
    static let folder = "folder.fill"
    static let folderOutline = "folder"
    static let chart = "chart.bar.fill"
    static let chartLine = "chart.line.uptrend.xyaxis"
    static let list = "list.bullet"
    
    // MARK: - Communication Icons
    static let notification = "bell.fill"
    static let notificationOutline = "bell"
    static let message = "message.fill"
    static let messageOutline = "message"
    static let mail = "envelope.fill"
    static let mailOutline = "envelope"
    
    // MARK: - Location Icons
    static let location = "location.fill"
    static let locationOutline = "location"
    static let mapPin = "mappin.circle.fill"
    static let building = "building.2.fill"
    
    // MARK: - Miscellaneous
    static let eye = "eye.fill"
    static let eyeSlash = "eye.slash.fill"
    static let lock = "lock.fill"
    static let unlock = "lock.open.fill"
    static let star = "star.fill"
    static let starOutline = "star"
    static let heart = "heart.fill"
    static let heartOutline = "heart"
}

// MARK: - Icon View Helper
// Convenience view for displaying icons with consistent styling
// Usage: IconView(.checkIn, size: .medium, color: .success)

struct IconView: View {
    let icon: String
    let size: IconSize
    let color: Color
    
    enum IconSize {
        case small, medium, large, xlarge
        
        var dimension: CGFloat {
            switch self {
            case .small: return AppTheme.Configuration.iconSizeSmall
            case .medium: return AppTheme.Configuration.iconSizeMedium
            case .large: return AppTheme.Configuration.iconSizeLarge
            case .xlarge: return 48
            }
        }
    }
    
    init(_ icon: String, size: IconSize = .medium, color: Color = ColorPalette.textPrimary) {
        self.icon = icon
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: size.dimension, height: size.dimension)
            .foregroundColor(color)
    }
}

// MARK: - Icon Extension for Easy Usage
extension Image {
    init(icon: String) {
        self.init(systemName: icon)
    }
}
