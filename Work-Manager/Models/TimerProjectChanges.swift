//
//  TimerProjectChanges.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import Foundation

/// Modell für Änderungen an einem Timer-Projekt.
struct TimerProjectChanges: Encodable {
    var id: UUID
    var title: String?
    var description: String?
    var salary: Double?
    var currency: String?
    var isFavorite: Bool?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let title = title { try container.encode(title, forKey: .title) }
        if let description = description { try container.encode(description, forKey: .description) }
        if let salary = salary { try container.encode(salary, forKey: .salary) }
        if let currency = currency { try container.encode(currency, forKey: .currency) }
        if let isFavorite = isFavorite { try container.encode(isFavorite, forKey: .isFavorite) }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, salary, currency, isFavorite
    }
}
