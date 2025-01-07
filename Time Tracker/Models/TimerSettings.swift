//
//  TimerSettings.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import Foundation

struct TimerSettings : Codable, Hashable {
    
    var filter = "Favorite"
    var filterOptions = [
        "Favorite",
        "Name",
        "Salary",
    ]
}
