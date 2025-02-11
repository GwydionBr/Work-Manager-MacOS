//
//  AppDelegate+Shortcuts.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import AppKit

// MARK: - Shortcuts
extension AppDelegate {
    
    func registerShortcuts() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }
            let commandPressed = event.modifierFlags.contains(.command)
            
            if commandPressed {
                switch event.charactersIgnoringModifiers {
                case "p":
                    if self.timeTracker.state == .running { self.pauseTimerSelected() }
                case "t":
                    if self.timeTracker.state == .running { self.stopTimerSelected() }
                case "k":
                    if self.timeTracker.state == .paused { self.continueTimerSelected() }
                case "s":
                    if self.timeTracker.state == .stopped { self.startTimerSelected() }
                default:
                    break
                }
            }
            return event
        }
    }
}
