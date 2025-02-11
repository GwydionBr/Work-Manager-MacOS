//
//  SettingOptions.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import Foundation

struct SettingOptions: Codable, Hashable {
    var filter = "Favorite"
    var filterOptions = [
        "Favorite",
        "Name",
        "Salary",
    ]
}
