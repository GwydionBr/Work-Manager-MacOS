//
//  ProjectWorkView.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 21.01.25.
//

import SwiftUI

struct ProjectWorkView: View {
    @EnvironmentObject var timerData: TimerData
    @EnvironmentObject var timeTracker: TimeTracker
    @Binding var project: TimerProject
    
    var body: some View {
        HSplitView {
            // Linke Ansicht
            SessionList(project: $project)
                .frame(minWidth: 450, maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .layoutPriority(1) // Höhere Priorität, damit diese Ansicht weniger Platz verliert

            // Rechte Ansicht
            TimeTrackerView(project: $project)
                .frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(2) // Höhere Priorität für TimeTrackerView, um mehr Platz zu bekommen
                .onChange(of: project) { oldValue, newValue in
                    if timeTracker.state == .stopped {
                        timeTracker.configureProject(salary: project.salary, currency: project.currency, projectId: project.id, projectName: project.title)
                    }
                }
                .onAppear {
                    // TimeTracker initialisieren
                    if timeTracker.state == .stopped {
                        timeTracker.configureProject(salary: project.salary, currency: project.currency, projectId: project.id, projectName: project.title)
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("\(project.title) - \(project.description)")
    }
}

#Preview {
    ProjectWorkView(project: .constant(TimerData.getStaticProject()))
        .environmentObject(TimerData())
        .environmentObject(TimeTracker())
}
