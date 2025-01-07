//
//  SessionList.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct SessionList: View {
    
    @ObservedObject var timerData: TimerData
    @Binding var project: TimerProject
    
    var body: some View {
        List {
            ForEach($project.sessions) { $session in
                SessionRow(session: $session)
            }
        }
    }
}

#Preview {
    SessionList(timerData: TimerData(),project: .constant(TimerData().projects[0]))
}
