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
        HStack {
            SessionList(timerData: TimerData(), project: $project)
                
        }
        .navigationTitle("\(project.title) - \(project.description)")
    }
}

#Preview {
    ProjectDetail(timerData: TimerData(), project: .constant(TimerData().projects[0]))
}
