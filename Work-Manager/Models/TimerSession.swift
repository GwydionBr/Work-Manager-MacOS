//
//  TimerSession.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import Foundation

/// Das Model für eine Timer-Session.
struct TimerSession: Codable, Identifiable, Hashable {
    var id = UUID()
    var activeSeconds: Int = 0
    var pausedSeconds: Int = 0
    var startTime: Date = Date()
    var endTime: Date = Date()
    var salary: Double = 10 // in $/h
    var currency: String = Constants.Currency.defaultCurrency // Annahme: Constants ist definiert.
    var projectId = UUID()
    var userId: UUID = UUID()
    
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
        return "\(dateFormatter.string(from: startTime)) - \(dateFormatter.string(from: endTime))"
    }
    
    func getEarnedMoney() -> String {
        let value = Double(activeSeconds) * salary / 3600
        return String(format: "%.2f", value)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, salary, currency
        case activeSeconds = "active_seconds"
        case pausedSeconds = "paused_seconds"
        case startTime = "start_time"
        case endTime = "end_time"
        case projectId = "project_id"
        case userId = "user_id"
    }
}
