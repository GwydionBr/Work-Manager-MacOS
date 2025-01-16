//
//  ProjectDetail.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct ProjectDetail: View {
    @EnvironmentObject var timerData: TimerData
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("\(project.title) - \(project.description)")
    }
}


//        HStack {
//            SessionList(timerData: TimerData(), project: $project)
//            TimeTrackerView()
//                .padding()
//        }

#Preview {
    ProjectDetail(project: .constant(TimerData().getStaticProject()))
        .environmentObject(TimerData())
}
