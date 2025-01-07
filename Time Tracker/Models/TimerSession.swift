//
//  TimerSession.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import Foundation

struct TimerSession : Codable, Identifiable, Hashable {
    var id = UUID()
    var activeTime = 0 // in seconds
    var pausedTime = 0 // in seconds
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
    
    func getEarnedMoney() -> String {
        let value = Double(activeTime) * salary / 3600
        return String(format: "%.2f", value) + " " + currency
    }
}
