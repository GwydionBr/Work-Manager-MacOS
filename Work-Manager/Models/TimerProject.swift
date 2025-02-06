//
//  TimerProject.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct TimerProject: Codable, Identifiable, Hashable {
    var id = UUID()
    var title = ""
    var description = ""
    var salary  = 0.0
    var currency = "$"
    var isFavorite = false
    var userId: UUID = UUID()
    var timerSession: [TimerSession]?
    
    func getSalary() -> String {
        return roundToMaxTwoDecimals(number: salary)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, salary, currency, timerSession
        case isFavorite = "is_favorite"
        case userId = "user_id"
    }
    
}


struct TimerProjectChanges: Encodable {
    var id: UUID
    var title: String?
    var description: String?
    var salary: Double?
    var currency: String?
    var isFavorite: Bool?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let title = title {
            try container.encode(title, forKey: .title)
        }
        if let description = description {
            try container.encode(description, forKey: .description)
        }
        if let salary = salary {
            try container.encode(salary, forKey: .salary)
        }
        if let currency = currency {
            try container.encode(currency, forKey: .currency)
        }
        if let isFavorite = isFavorite {
            try container.encode(isFavorite, forKey: .isFavorite)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, salary, currency, isFavorite
    }
}
