//
//  AppDelegate.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 16.01.25.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    static var shared: AppDelegate? = nil
    
    var statusItem: NSStatusItem?
    var timer: Timer?
    var image1 = NSImage(systemSymbolName: "clock.fill", accessibilityDescription: "Clock")
    var image2 = NSImage(systemSymbolName: "clock", accessibilityDescription: "Clock")
    
    var timeTracker: TimeTracker?
    var timerData: TimerData?
    var dynamicMenu = NSMenu()
    
    override init() {
        super.init()
        AppDelegate.shared = self
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.action = #selector(statusBarClicked)
            button.image = image1
        }
        
        setupMenu()
        
        registerShortcuts()
    }
    
    func setupMenu() {
        // Initial menu setup (updated dynamically later)
        dynamicMenu = NSMenu()
        updateMenuItems()
        statusItem?.menu = dynamicMenu
    }
    
    func updateMenuItems() {
        dynamicMenu.removeAllItems()
        
        // Dynamically add menu items based on the timer state
        if timeTracker?.isRunning == true {
            let pauseItem = NSMenuItem(title: "Pause Timer", action: #selector(pauseTimerSelected), keyEquivalent: "p")
            pauseItem.keyEquivalentModifierMask = [.command] // Command + P
            dynamicMenu.addItem(pauseItem)
            
            let stopItem = NSMenuItem(title: "Stop Timer", action: #selector(stopTimerSelected), keyEquivalent: "t")
            stopItem.keyEquivalentModifierMask = [.command] // Command + T
            dynamicMenu.addItem(stopItem)
        } else {
            let continueItem = NSMenuItem(title: "Continue Timer", action: #selector(continueTimerSelected), keyEquivalent: "s")
            continueItem.keyEquivalentModifierMask = [.command] // Command + S
            dynamicMenu.addItem(continueItem)
        }
        
        dynamicMenu.addItem(NSMenuItem.separator()) // Add a separator
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.keyEquivalentModifierMask = [.command] // Command + Q
        dynamicMenu.addItem(quitItem)
    }
    
    @objc func statusBarClicked() {
        // Implement your own action here
    }
    
    @objc func continueTimerSelected() {
        timeTracker?.continueTimer()
        updateMenuItems()
    }
    
    @objc func stopTimerSelected() {
        if let newSession = timeTracker?.stopTimer() {
            Task {
                await timerData?.addSession(newSession)
            }
        }
        updateMenuItems()
    }
    
    @objc func pauseTimerSelected() {
        timeTracker?.pauseTimer()
        updateMenuItems()
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    func updateStatusBarText(with time: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusItem?.button?.title = time
        }
    }
    
    func startTimerClock() {
        DispatchQueue.main.async { [weak self] in
            if let button = self?.statusItem?.button {
                button.image? = self?.image2 ?? NSImage()
            }
        }
    }
    
    func stopTimerClock() {
        DispatchQueue.main.async { [weak self] in
            if let button = self?.statusItem?.button {
                button.image? = self?.image1 ?? NSImage()
            }
        }
    }
    
    private func registerShortcuts() {
        // Add a local monitor for key events within the app's context
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }
            
            // Check for Command key modifier
            let commandPressed = event.modifierFlags.contains(.command)
            
            if commandPressed {
                switch event.charactersIgnoringModifiers {
                case "p": // Command + P
                    if self.timeTracker?.isRunning == true {
                        self.pauseTimerSelected()
                        return nil // Consume the event
                    }
                case "t": // Command + T
                    if self.timeTracker?.isRunning == true {
                        self.stopTimerSelected()
                        return nil // Consume the event
                    }
                case "s": // Command + S
                    if self.timeTracker?.isRunning == false {
                        self.continueTimerSelected()
                        return nil // Consume the event
                    }
                default:
                    break
                }
            }
            
            return event // Pass the event to the system if not handled
        }
    }
}
