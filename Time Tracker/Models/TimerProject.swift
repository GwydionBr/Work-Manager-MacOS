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
    var salary = 0.0
    var currency = "$"
    var isFavorite = false
    var sessions: [TimerSession] = []
    
    func getSalary() -> String {
        return roundToMaxTwoDecimals(number: salary)
    }
    
}
