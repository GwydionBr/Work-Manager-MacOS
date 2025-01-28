//
//  TimeTracker.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 08.01.25.
//

import SwiftUI


// MARK: - TimerState
enum TimerState {
    case stopped
    case running
    case paused
}

// MARK: - TimeTracker
class TimeTracker: ObservableObject {
    // MARK: - Published Properties
    @Published var moneyEarned: String = "0.00"
    @Published var activeTime: String = "00:00"
    @Published var pausedTime: String = "00:00"
    @Published private(set) var state: TimerState = .stopped
    @Published private(set) var projectTitle: String = ""
    @Published private(set) var currency: String = "$"

    // MARK: - Project Data
    private var projectId: UUID = UUID()
    private var salary: Double = 0.0
    
    // MARK: - Timer Variables
    private var startTime: Date = Date()
    private var tempStartTime: Date = Date()
    private var activeSeconds: TimeInterval = 0
    private var storedActiveSeconds: TimeInterval = 0
    private var pausedSeconds: TimeInterval = 0
    private var storedPausedSeconds: TimeInterval = 0
    private var timer: Timer?
    
    
    // MARK: - Public Methods
    func configureProject(salary: Double, currency: String, projectId: UUID, projectName: String) {
        self.resetTimer()
        self.salary = salary
        self.currency = currency
        self.projectId = projectId
        self.projectTitle = projectName
    }
    
    func startTimer() {
        guard state == .stopped, projectTitle != "" else { return }
        startTime = Date()
        tempStartTime = Date()
        state = .running
        notifyMenuBarStatus()
        startTimerLoop()
    }
    
    func pauseTimer() {
        guard state == .running else { return }
        storeActiveSeconds()
        tempStartTime = Date()
        state = .paused
        notifyMenuBarStatus()
        startPausedTimerLoop()
    }
    
    func resumeTimer() {
        guard state == .paused else { return }
        storePausedSeconds()
        tempStartTime = Date()
        state = .running
        notifyMenuBarStatus()
        startTimerLoop()
    }
    
    func stopTimer() -> TimerSession? {
        guard state != .stopped else { return nil }
        let newSession = TimerSession(
            activeSeconds: Int(activeSeconds),
            pausedSeconds: Int(pausedSeconds),
            startTime: startTime,
            endTime: Date(),
            salary: salary,
            currency: currency,
            projectId: projectId
        )
        resetTimer()
        
        return newSession
    }
    
    func cancelTimer() {
        resetTimer()
    }
    
    func resetTimer() {
        timer?.invalidate()
        state = .stopped
        activeSeconds = 0
        pausedSeconds = 0
        storedActiveSeconds = 0
        storedPausedSeconds = 0
        salary = 0.0
        moneyEarned = "0.00"
        activeTime = "00:00"
        pausedTime = "00:00"
        notifyMenuBar()
        notifyMenuBarStatus()
    }
    
    
    // MARK: - Private Methods
    private func startTimerLoop() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.activeSeconds = Date().timeIntervalSince(self.tempStartTime) + self.storedActiveSeconds
            self.activeTime = formatTimerSeconds(Int(self.activeSeconds))
            self.setMoneyEarned()
            self.notifyMenuBar()
        }
    }
    
    private func startPausedTimerLoop() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.pausedSeconds = Date().timeIntervalSince(self.tempStartTime) + self.storedPausedSeconds
            self.pausedTime = formatTimerSeconds(Int(self.pausedSeconds))
        }
    }
    
    private func storeActiveSeconds() {
        storedActiveSeconds = activeSeconds
    }
    
    private func storePausedSeconds() {
        storedPausedSeconds = pausedSeconds
    }
    
    private func notifyMenuBar() {
        if let appDelegate = AppDelegate.shared {
            if state == .running {
                appDelegate.updateStatusBarText(with: activeTime)
            } else {
                appDelegate.updateStatusBarText(with: "")
            }
        } else {
            print("AppDelegate.shared is nil") // Debug
        }
    }
    
    private func notifyMenuBarStatus() {
        if let appDelegate = AppDelegate.shared {
            if state == .running {
                appDelegate.startTimerClock()
            } else {
                appDelegate.stopTimerClock()
            }
            appDelegate.updateMenuItems()
        } else {
            print("AppDelegate.shared is nil") // Debug
        }
    }
    
    
}


// MARK: Timer Logic

extension TimeTracker {
    
    
    func setMoneyEarned() {
        let value = self.activeSeconds * self.salary / 3600
        self.moneyEarned =  String(format: "%.2f", value)
    }
}


