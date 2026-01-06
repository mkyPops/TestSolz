//
//  EmployeeHomeView.swift
//  TestSolz
//
//  Created by Mashaal Khan on 27/12/2025.
//

import SwiftUI

// MARK: - Employee Home View
// Main screen for employees - view status, tasks, and attendance

struct EmployeeHomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var attendanceViewModel = EmployeeHomeViewModel()
    @StateObject private var tasksViewModel = TasksViewModel()
    
    // Create task state
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var newTaskPriority: TaskItem.TaskPriority = .medium
    
    // Edit project state
    @State private var showEditProject = false
    @State private var editProjectName = ""
    
    var body: some View {
            ZStack {
                // Background
                ColorPalette.backgroundSecondary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Header
                        headerSection
                        
                        // Current Status Card
                        currentStatusCard
                        
                        // Today's Info (if checked in)
                        if attendanceViewModel.todayAttendance != nil {
                            todayInfoSection
                        }
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Project & Tasks Section
                        if tasksViewModel.currentProject != nil {
                            projectSection
                            tasksSection
                        }
                        
                        // History Button
                        historyButton
                        
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, Spacing.screenVertical)
                }
                .refreshable {
                    await attendanceViewModel.fetchTodayStatus()
                    await tasksViewModel.fetchProjectAndTasks(userId: authViewModel.currentUser?.id ?? "")
                }
                
                // Loading overlay
                if attendanceViewModel.isLoading && attendanceViewModel.todayAttendance == nil {
                    loadingOverlay
                }
            }
            .task {
                await attendanceViewModel.fetchTodayStatus()
                await tasksViewModel.fetchProjectAndTasks(userId: authViewModel.currentUser?.id ?? "")
            }
            .sheet(isPresented: $tasksViewModel.showCreateTask) {
                CreateTaskView(
                    title: $newTaskTitle,
                    description: $newTaskDescription,
                    priority: $newTaskPriority
                ) {
                    Task {
                        await tasksViewModel.createTask(
                            title: newTaskTitle,
                            description: newTaskDescription.isEmpty ? nil : newTaskDescription,
                            priority: newTaskPriority,
                            userId: authViewModel.currentUser?.id ?? ""
                        )
                        // Reset fields
                        newTaskTitle = ""
                        newTaskDescription = ""
                        newTaskPriority = .medium
                    }
                }
            }
            .sheet(isPresented: $showEditProject) {
                EditProjectView(
                    projectName: $editProjectName
                ) {
                    Task {
                        await tasksViewModel.updateProjectName(editProjectName)
                    }
                }
            }
        
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Welcome back,")
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                
                Text(authViewModel.currentUser?.name ?? "Employee")
                    .font(AppTypography.headlineLarge)
                    .foregroundColor(ColorPalette.textPrimary)
            }
            
            Spacer()
            
            // Profile button
            NavigationLink(destination: ProfileView()) {
                Image(systemName: AppIcons.user)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorPalette.textSecondary)
            }
        }
    }
    
    // MARK: - Current Status Card
    private var currentStatusCard: some View {
        Group {
            if let attendance = attendanceViewModel.todayAttendance {
                StatusCard(
                    icon: attendance.isCheckedOut ? AppIcons.checkOut : AppIcons.checkIn,
                    title: attendance.isCheckedOut ? "Checked Out" : "Checked In",
                    subtitle: attendance.isCheckedOut
                        ? "Today at \(attendance.checkOutTime!.formatted(style: "time"))"
                        : "Today at \(attendance.checkInTime.formatted(style: "time"))",
                    statusColor: attendance.isCheckedOut ? ColorPalette.textSecondary : ColorPalette.success
                )
            } else {
                StatusCard(
                    icon: AppIcons.clock,
                    title: "Not Checked In",
                    subtitle: "Use your card at the office reader to check in",
                    statusColor: ColorPalette.textTertiary
                )
            }
        }
    }
    
    // MARK: - Today's Info Section
    private var todayInfoSection: some View {
        Group {
            if let attendance = attendanceViewModel.todayAttendance {
                BaseCard {
                    VStack(spacing: Spacing.md) {
                        HStack {
                            Text("Today's Details")
                                .font(AppTypography.titleSmall)
                                .foregroundColor(ColorPalette.textPrimary)
                            Spacer()
                        }
                        
                        Divider()
                            .background(ColorPalette.divider)
                        
                        infoRow(
                            icon: AppIcons.checkIn,
                            label: "Check In",
                            value: attendance.checkInTime.formatted(style: "time"),
                            color: ColorPalette.success
                        )
                        
                        if let checkOutTime = attendance.checkOutTime {
                            infoRow(
                                icon: AppIcons.checkOut,
                                label: "Check Out",
                                value: checkOutTime.formatted(style: "time"),
                                color: ColorPalette.textSecondary
                            )
                        } else {
                            infoRow(
                                icon: AppIcons.checkOut,
                                label: "Check Out",
                                value: "Not yet",
                                color: ColorPalette.textTertiary
                            )
                        }
                        
                        infoRow(
                            icon: AppIcons.info,
                            label: "Status",
                            value: attendance.status.displayName,
                            color: attendance.status.color
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Project Section
    private var projectSection: some View {
        Group {
            if let project = tasksViewModel.currentProject {
                ProjectCard(
                    project: project,
                    pendingTasks: tasksViewModel.pendingTasksCount,
                    completedTasks: tasksViewModel.completedTasksCount,
                    onEdit: {
                        editProjectName = project.name
                        showEditProject = true
                    }
                )
            }
        }
    }
    
    // MARK: - Tasks Section
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("My Tasks")
                    .font(AppTypography.labelMedium)
                    .foregroundColor(ColorPalette.textSecondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Spacer()
                
                Button(action: {
                    tasksViewModel.showCreateTask = true
                }) {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: AppIcons.add)
                            .font(.system(size: 14, weight: .semibold))
                        Text("New Task")
                            .font(AppTypography.labelSmall)
                    }
                    .foregroundColor(ColorPalette.primary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(ColorPalette.primaryLight)
                    .cornerRadius(Radius.sm)
                }
            }
            
            // Active tasks
            if tasksViewModel.activeTasks.isEmpty {
                emptyTasksState
            } else {
                ForEach(tasksViewModel.activeTasks) { task in
                    TaskCard(
                        task: task,
                        onToggle: {
                            Task {
                                await tasksViewModel.toggleTaskCompletion(task)
                            }
                        },
                        onDelete: {
                            Task {
                                await tasksViewModel.deleteTask(task)
                            }
                        }
                    )
                }
            }
            
            // Completed tasks (collapsible)
            if !tasksViewModel.completedTasks.isEmpty {
                DisclosureGroup {
                    ForEach(tasksViewModel.completedTasks) { task in
                        TaskCard(
                            task: task,
                            onToggle: {
                                Task {
                                    await tasksViewModel.toggleTaskCompletion(task)
                                }
                            },
                            onDelete: {
                                Task {
                                    await tasksViewModel.deleteTask(task)
                                }
                            }
                        )
                    }
                } label: {
                    Text("Completed (\(tasksViewModel.completedTasksCount))")
                        .font(AppTypography.bodySmall)
                        .foregroundColor(ColorPalette.textSecondary)
                }
                .accentColor(ColorPalette.primary)
            }
        }
    }
    
    // MARK: - Empty Tasks State
    private var emptyTasksState: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(ColorPalette.textTertiary)
            
            Text("No active tasks")
                .font(AppTypography.bodySmall)
                .foregroundColor(ColorPalette.textSecondary)
            
            Text("Tap 'New Task' to create one")
                .font(AppTypography.captionSmall)
                .foregroundColor(ColorPalette.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
        .background(ColorPalette.cardBackground)
        .cornerRadius(Radius.card)
    }
    
    // MARK: - Info Row
    private func infoRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.bodyMedium)
                .foregroundColor(ColorPalette.textPrimary)
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Today")
                .font(AppTypography.labelMedium)
                .foregroundColor(ColorPalette.textSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            HStack(spacing: Spacing.md) {
                MetricCard(
                    icon: AppIcons.clock,
                    title: "Hours Worked",
                    value: attendanceViewModel.todayAttendance?.hoursWorked != nil
                        ? String(format: "%.1fh", attendanceViewModel.todayAttendance!.hoursWorked!)
                        : "0h",
                    accentColor: ColorPalette.primary
                )
                
                MetricCard(
                    icon: AppIcons.checkIn,
                    title: "Status",
                    value: attendanceViewModel.todayAttendance?.status.displayName ?? "Absent",
                    accentColor: attendanceViewModel.todayAttendance?.status.color ?? ColorPalette.textTertiary
                )
            }
        }
    }
    
    // MARK: - History Button
    private var historyButton: some View {
        NavigationLink(destination: AttendanceHistoryView()) {
            BaseCard(padding: Spacing.md) {
                HStack(spacing: Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(ColorPalette.primaryLight)
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: AppIcons.calendar)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(ColorPalette.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("View History")
                            .font(AppTypography.titleSmall)
                            .foregroundColor(ColorPalette.textPrimary)
                        
                        Text("See your past attendance")
                            .font(AppTypography.captionMedium)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: AppIcons.forward)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorPalette.textTertiary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: ColorPalette.primary))
                .scaleEffect(1.5)
        }
    }
}

// MARK: - Preview
#Preview {
    EmployeeHomeView()
        .environmentObject(AuthenticationViewModel())
}
