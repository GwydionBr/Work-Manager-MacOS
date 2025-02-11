//
//  AppDelegate+Menu.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import AppKit

// MARK: - Menu Setup
extension AppDelegate {
    
    func setupMenu() {
        dynamicMenu = NSMenu()
        updateMenuItems()
        statusItem?.menu = dynamicMenu
    }
    
    func updateMenuItems() {
        dynamicMenu.removeAllItems()
        
        // Menüeinträge basierend auf dem Timer-Zustand
        switch timeTracker.state {
        case .running:
            let pauseItem = NSMenuItem(title: "Pause Timer", action: #selector(pauseTimerSelected), keyEquivalent: "p")
            pauseItem.keyEquivalentModifierMask = [.command]
            dynamicMenu.addItem(pauseItem)
            
            let stopItem = NSMenuItem(title: "Stop Timer", action: #selector(stopTimerSelected), keyEquivalent: "t")
            stopItem.keyEquivalentModifierMask = [.command]
            dynamicMenu.addItem(stopItem)
            
        case .paused:
            let continueItem = NSMenuItem(title: "Continue Timer", action: #selector(continueTimerSelected), keyEquivalent: "k")
            continueItem.keyEquivalentModifierMask = [.command]
            dynamicMenu.addItem(continueItem)
            
        case .stopped:
            let startItem = NSMenuItem(title: "Start Timer", action: #selector(startTimerSelected), keyEquivalent: "s")
            startItem.keyEquivalentModifierMask = [.command]
            dynamicMenu.addItem(startItem)
        }
        
        dynamicMenu.addItem(NSMenuItem.separator())
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.keyEquivalentModifierMask = [.command]
        dynamicMenu.addItem(quitItem)
    }
}
