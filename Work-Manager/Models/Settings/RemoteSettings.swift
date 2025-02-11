//
//  GeneralSettings.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 06.02.25.
//

import Foundation

struct RemoteSettings: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var defaultCurrency: String
    var roundingOption: String
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case defaultCurrency = "default_currency"
        case roundingOption = "rounding_option"
        case userId = "user_id"
    }
}
