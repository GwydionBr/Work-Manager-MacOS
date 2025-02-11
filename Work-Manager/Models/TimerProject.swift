//
//  TimerProject.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

/// Das Model für ein Timer-Projekt.
struct TimerProject: Codable, Identifiable, Hashable {
    var id = UUID()
    var title = ""
    var description = ""
    var salary = 0.0
    var currency = "$"
    var isFavorite = false
    var userId: UUID = UUID()
    var timerSession: [TimerSession]?
    
    /// Gibt den formatierten Gehalt-Wert zurück.
    func getSalary() -> String {
        return roundToMaxTwoDecimals(number: salary)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, salary, currency, timerSession
        case isFavorite = "is_favorite"
        case userId = "user_id"
    }
}
