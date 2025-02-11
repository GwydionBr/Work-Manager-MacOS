//
//  AppDelegate+TimerActions.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import AppKit

// MARK: - Timer Actions
extension AppDelegate {
    
    @objc func startTimerSelected() {
        timeTracker.startTimer()
        updateMenuItems()
    }
    
    @objc func continueTimerSelected() {
        timeTracker.resumeTimer()
        updateMenuItems()
    }
    
    @objc func stopTimerSelected() {
        if var newSession = timeTracker.stopTimer() {
            Task {
                let user = try await supabase.auth.session.user
                newSession.userId = user.id
                await timerData.addSession(newSession)
            }
        }
        updateMenuItems()
    }
    
    @objc func pauseTimerSelected() {
        timeTracker.pauseTimer()
        updateMenuItems()
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
