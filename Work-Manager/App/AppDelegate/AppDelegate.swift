//
//  AppDelegate.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 16.01.25.
//

import SwiftUI
import AppKit

/// Der zentrale App-Delegate verwaltet u. a. die Statusbar und UI-Aktualisierungen.
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    // MARK: - Properties
    static var shared: AppDelegate? = nil
    var timerData = TimerData()
    var timeTracker = TimeTracker()
    
    var statusItem: NSStatusItem?
    var imageTimerStop = NSImage(systemSymbolName: "clock.fill", accessibilityDescription: "Clock")
    var imageTimerRunning = NSImage(systemSymbolName: "clock", accessibilityDescription: "Clock")
    var dynamicMenu = NSMenu()
    
    // MARK: - Initializer
    override init() {
        super.init()
        AppDelegate.shared = self

    }
    
    // MARK: - Application Lifecycle
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupMenu()
        registerShortcuts()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.action = #selector(statusBarClicked)
            button.image = imageTimerStop
        }
    }
    
    @objc func statusBarClicked() {
        // Eigene Aktion hier implementieren.
    }
    
    // MARK: - UI Update Methods
    func updateStatusBarText(with time: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusItem?.button?.title = time
        }
    }
    
    func startTimerClock() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let button = self.statusItem?.button else { return }
            button.image = self.imageTimerRunning ?? NSImage()
        }
    }
    
    func stopTimerClock() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let button = self.statusItem?.button else { return }
            button.image = self.imageTimerStop ?? NSImage()
        }
    }
}
