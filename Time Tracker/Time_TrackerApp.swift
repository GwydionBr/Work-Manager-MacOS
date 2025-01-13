//
//  Time_TrackerApp.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

@main
struct Time_TrackerApp: App {
    @StateObject private var timerData = TimerData()
    
    var body: some Scene {
        WindowGroup {
            ProjectList(timerData: timerData)
                .onAppear {
                    Task {
                        await timerData.loadOnlineProjects()
                    }
                }
//                .onDisappear {
//                    Task {
//                        await timerData.addProject()
//                    }
//                }
//            TestView()
        }
    }
}


