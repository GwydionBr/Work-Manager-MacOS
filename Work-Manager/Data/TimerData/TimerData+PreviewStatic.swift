//
//  TimerData+PreviewStatic.swift.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import SwiftUI

// MARK: - Static Content for Previews
extension TimerData {
    
    static func getStaticSession() -> TimerSession {
        TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 30.0, currency: "$")
    }
    
    static func getStaticProject() -> TimerProject {
        TimerProject(title: "Tango", description: "Rate responses as safe / unsafe", salary: 26.0, currency: "$", isFavorite: false, timerSession: [getStaticSession()])
    }
}
