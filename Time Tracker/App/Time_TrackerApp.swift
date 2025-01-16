//
//  Time_TrackerApp.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

@main
struct Time_TrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var timerData = TimerData()
    @StateObject private var timeTracker = TimeTracker()
    
    var body: some Scene {
        WindowGroup {
            ProjectList()
                .environmentObject(timerData) 
                .environmentObject(timeTracker)
                .onAppear {
                    Task {
                        await timerData.loadProjects()
                    }
                }
                .onDisappear {
                    Task {
                        timerData.saveOfflineProjects()
                        timeTracker.resetTimer()
                    }
                }
            //            TestView()
        }
        .commands {
            WorkManagerCommands()
        }
    }
}

