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
    @Published var activeTimeText: String = "00:00"
    var image1 = NSImage(systemSymbolName: "clock.fill", accessibilityDescription: "Clock")
    var image2 = NSImage(systemSymbolName: "clock", accessibilityDescription: "Clock")
    
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
    }

    @objc func statusBarClicked() {
        NSApp.activate(ignoringOtherApps: true)
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
    
    func applicationWillTerminate(_ notification: Notification) {
        timer?.invalidate()
    }
}
