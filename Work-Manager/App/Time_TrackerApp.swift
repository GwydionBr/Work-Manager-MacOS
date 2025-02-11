//
//  Time_TrackerApp.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

@main
struct TimeTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authModel = AuthModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appDelegate.timerData)
                .environmentObject(appDelegate.timeTracker)
                .environmentObject(authModel)
                .onOpenURL { url in
                    Task {
                        do {
                            try await supabase.auth.session(from: url)
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
        }
        .commands {
            WorkManagerCommands()
        }
        Settings {
            SettingsRootView()
                .environmentObject(appDelegate.timerData)
                .environmentObject(authModel)
        }
    }
}


