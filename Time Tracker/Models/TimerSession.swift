//
//  TimerSession.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import Foundation

struct TimerSession : Codable, Identifiable, Hashable {
    var id = UUID()
    var activeSeconds = 0
    var pausedSeconds = 0
    var startTime = Date.now
    var endTime = Date.now
    var salary = 0.0  // in $/h
    var currency = "$"
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: startTime)
    }
    
    func getTimeSpan() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: startTime) + " - " + dateFormatter.string(from: endTime)
    }
    
    func getEarnedMoney() -> String {
        let value = Double(activeSeconds) * salary / 3600
        return String(format: "%.2f", value)
    }
}
