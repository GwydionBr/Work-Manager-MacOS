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
    
    @State private var listWidth: CGFloat = 200
    
    var body: some View {
        GeometryReader { geometry in
                    HStack(spacing: 0) {
                        SessionList(timerData: TimerData(), project: $project)
                        .background(Color.gray.opacity(0.2))
                        .frame(width: listWidth)

                        Divider()
                            .frame(width: 3)
                            .background(Color.gray)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newWidth = listWidth + value.translation.width
                                        if newWidth > 100 && newWidth < geometry.size.width - 100 {
                                            listWidth = newWidth
                                        }
                                    }
                            )

                        VStack {
                            TimeTrackerView(project: $project)
                                
                        }
                        .frame(width: geometry.size.width - listWidth - 5)
                    }
                }
//        HStack {
//            SessionList(timerData: TimerData(), project: $project)
//            TimeTrackerView()
//                .padding()
//        }
//        .navigationTitle("\(project.title) - \(project.description)")
    }
}

#Preview {
    ProjectDetail(timerData: TimerData(), project: .constant(TimerData().projects[0]))
}
