//
//  AppDelegate.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 16.01.25.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    static var shared: AppDelegate? = nil
    
    var timerData = TimerData()
    var timeTracker = TimeTracker()
    
    var statusItem: NSStatusItem?
    var timer: Timer?
    var imageTimerStop = NSImage(systemSymbolName: "clock.fill", accessibilityDescription: "Clock")
    var imageTimerRunning = NSImage(systemSymbolName: "clock", accessibilityDescription: "Clock")
    
    var dynamicMenu = NSMenu()
    
    override init() {
        super.init()
        AppDelegate.shared = self
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.action = #selector(statusBarClicked)
            button.image = imageTimerStop
        }
        
        setupMenu()
        
        registerShortcuts()
    }
    
    
    
    @objc func statusBarClicked() {
        // Implement your own action here
    }
    
    
    
    func updateStatusBarText(with time: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusItem?.button?.title = time
        }
    }
    
    func startTimerClock() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let button = self.statusItem?.button {
                button.image? = self.imageTimerRunning ?? NSImage()
            }
        }
    }
    
    func stopTimerClock() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let button = self.statusItem?.button {
                button.image? = self.imageTimerStop ?? NSImage()
            }
        }
    }
}


// MARK: - Menu Setup

extension AppDelegate {
    func setupMenu() {
        // Initial menu setup (updated dynamically later)
        dynamicMenu = NSMenu()
        updateMenuItems()
        statusItem?.menu = dynamicMenu
    }
    
    
    
    func updateMenuItems() {
        dynamicMenu.removeAllItems()
        
        // Dynamically add menu items based on the timer state
        switch timeTracker.state {
        case .running:
            let pauseItem = NSMenuItem(title: "Pause Timer", action: #selector(pauseTimerSelected), keyEquivalent: "p")
            pauseItem.keyEquivalentModifierMask = [.command] // Command + P
            dynamicMenu.addItem(pauseItem)
            
            let stopItem = NSMenuItem(title: "Stop Timer", action: #selector(stopTimerSelected), keyEquivalent: "t")
            stopItem.keyEquivalentModifierMask = [.command] // Command + T
            dynamicMenu.addItem(stopItem)
        case .paused:
            let continueItem = NSMenuItem(title: "Continue Timer", action: #selector(continueTimerSelected), keyEquivalent: "k")
            continueItem.keyEquivalentModifierMask = [.command] // Command + K
            dynamicMenu.addItem(continueItem)
        case .stopped:
            let startItem = NSMenuItem(title: "Start Timer", action: #selector(startTimerSelected), keyEquivalent: "s")
            startItem.keyEquivalentModifierMask = [.command] // Command + S
            dynamicMenu.addItem(startItem)
        }
        
        dynamicMenu.addItem(NSMenuItem.separator()) // Add a separator
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.keyEquivalentModifierMask = [.command] // Command + Q
        dynamicMenu.addItem(quitItem)
    }
}

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
        if let newSession = timeTracker.stopTimer() {
            Task {
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

// MARK: - Shortcuts

extension AppDelegate {
    
    private func registerShortcuts() {
        // Add a local monitor for key events within the app's context
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }
            
            // Check for Command key modifier
            let commandPressed = event.modifierFlags.contains(.command)
            
            if commandPressed {
                switch event.charactersIgnoringModifiers {
                case "p": // Command + P
                    if timeTracker.state == .running {
                        self.pauseTimerSelected()
                    }
                case "t": // Command + T
                    if timeTracker.state == .running {
                        self.stopTimerSelected()
                    }
                case "k": // Command + S
                    if timeTracker.state == .paused {
                        self.continueTimerSelected()
                    }
                case "s": // Command + S
                    if timeTracker.state == .stopped {
                        self.startTimerSelected()
                    }
                default:
                    break
                }
            }
            
            return event // Pass the event to the system if not handled
        }
    }
}
