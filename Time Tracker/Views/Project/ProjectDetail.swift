//
//  ProjectDetail.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct ProjectDetail: View {
    @ObservedObject var timerData: TimerData
    @Binding var project: TimerProject

    var body: some View {
        HSplitView {
            // Linke Ansicht
            SessionList(timerData: TimerData(), project: $project)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity) // Flexible Breite
                .background(Color.gray.opacity(0.2))
                .layoutPriority(1) // Priorität erhöhen

            // Rechte Ansicht
            TimeTrackerView(project: $project)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity) // Flexible Breite
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
    ProjectDetail(timerData: TimerData(), project: .constant(TimerData().projects[0]))
}
