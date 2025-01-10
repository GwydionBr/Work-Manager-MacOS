//
//  TimeTracker.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 08.01.25.
//

import Foundation

class TimeTracker: ObservableObject {
    @Published var moneyEarned: String = "0.00"
    @Published var activeTime: String = "00:00"
    @Published var pausedTime: String = "00:00"
    @Published var isRunning = false
    @Published var isTimerActive = false
    
    var salary: Double = 0.0
    var currency: String = "$"
    var startTime: Date = Date()
    var tempStartTime: Date = Date()
    var endTime: Date = Date()
    
    var activeSeconds: TimeInterval = 0
    var storedActiveSeconds: TimeInterval = 0
    
    var pausedSeconds: TimeInterval = 0
    var storedPausedSeconds: TimeInterval = 0
    
    var newSession = TimerSession()
    
    private var timer: Timer?
    
    
    init(salary: Double = 0.0, currency: String = "$") {
        self.salary = salary
        self.currency = currency
    }
    
    
    // MARK: Timer Functions
    
    func startTimer() {
        guard !isRunning else { return }
        startTime = Date()
        tempStartTime = Date()
        isRunning = true
        isTimerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.activeSeconds = Date().timeIntervalSince(self.tempStartTime) + self.storedActiveSeconds
            self.activeTime = formatTimerSeconds(Int(self.activeSeconds))
            self.setMoneyEarned()
        }
    }
    
    
    func pauseTimer() {
        guard isRunning else { return }
        storedActiveSeconds = activeSeconds
        tempStartTime = Date()
        timer?.invalidate()
        isRunning = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.pausedSeconds = Date().timeIntervalSince(self.tempStartTime) + self.storedPausedSeconds
            self.pausedTime = formatTimerSeconds(Int(self.pausedSeconds))
        }
    }
    
    
    func continueTimer() {
        guard !isRunning else { return }
        storedPausedSeconds = pausedSeconds
        tempStartTime = Date()
        timer?.invalidate()
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.activeSeconds = Date().timeIntervalSince(self.tempStartTime) + self.storedActiveSeconds
            self.activeTime = formatTimerSeconds(Int(self.activeSeconds))
            self.setMoneyEarned()
        }
    }
    
    
    func stopTimer() -> TimerSession {
        endTime = Date()
        newSession = TimerSession(
            activeSeconds: Int(activeSeconds),
            pausedSeconds: Int(pausedSeconds),
            startTime: startTime,
            endTime: endTime,
            salary: salary,
            currency: currency)
        
        resetTimer()
        
        return newSession
    }
    
    
    func resetTimer() {
        isRunning = false
        timer?.invalidate()
        activeSeconds = 0
        pausedSeconds = 0
        storedActiveSeconds = 0
        storedPausedSeconds = 0
        salary = 0.0
        moneyEarned = "0.00"
        isTimerActive = false
        activeTime = "00:00"
        pausedTime = "00:00"
    }
}


// MARK: Timer Logic

extension TimeTracker {
    
    
    func setMoneyEarned() {
        let value = self.activeSeconds * self.salary / 3600
        self.moneyEarned =  String(format: "%.2f", value)
    }
    
    
    
    
    
}
