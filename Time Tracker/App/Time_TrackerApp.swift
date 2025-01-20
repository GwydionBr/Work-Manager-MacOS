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
    
    var body: some Scene {
        WindowGroup {
            ProjectList()
                .environmentObject(appDelegate.timerData)
                .environmentObject(appDelegate.timeTracker)
                .onAppear {
                    Task {
                        await appDelegate.timerData.loadProjects()
                    }
                }
                .onDisappear {
                    Task {
                        appDelegate.timerData.saveOfflineProjects()
                        appDelegate.timeTracker.resetTimer()
                    }
                }
        }
        .commands {
            WorkManagerCommands()
        }
    }
}


