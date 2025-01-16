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
    
    override init() {
        super.init()
        AppDelegate.shared = self
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("AppDelegate initialized") // Debug
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.action = #selector(statusBarClicked)
            button.title = "Time Tracker"
        }
    }

    @objc func statusBarClicked() {
        NSApp.activate(ignoringOtherApps: true)
    }

    func updateStatusBar(with time: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusItem?.button?.title = time
        }
    }
}
