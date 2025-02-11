//
//  TimerSessionChanges.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import Foundation

/// Modell für Änderungen an einer Timer-Session.
struct TimerSessionChanges: Encodable {
    var id: UUID
    var activeSeconds: Int?
    var pausedSeconds: Int?
    var startTime: Date?
    var endTime: Date?
    var salary: Double?
    var currency: String?
    var projectId: UUID?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let activeSeconds = activeSeconds { try container.encode(activeSeconds, forKey: .activeSeconds) }
        if let pausedSeconds = pausedSeconds { try container.encode(pausedSeconds, forKey: .pausedSeconds) }
        if let startTime = startTime { try container.encode(startTime, forKey: .startTime) }
        if let endTime = endTime { try container.encode(endTime, forKey: .endTime) }
        if let salary = salary { try container.encode(salary, forKey: .salary) }
        if let currency = currency { try container.encode(currency, forKey: .currency) }
        if let projectId = projectId { try container.encode(projectId, forKey: .projectId) }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, salary, currency
        case activeSeconds = "active_seconds"
        case pausedSeconds = "paused_seconds"
        case startTime = "start_time"
        case endTime = "end_time"
        case projectId = "project_id"
    }
}
