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
    @StateObject private var authModel = AuthModel(supabase)
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appDelegate.timerData)
                .environmentObject(appDelegate.timeTracker)
                .environmentObject(authModel)
                .onOpenURL { url in
                    Task {
                        do {
                            try await authModel.supabase.auth.session(from: url)
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
                
        }
        .commands {
            WorkManagerCommands()
        }
    }
}


