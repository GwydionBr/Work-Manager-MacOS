//
//  TimerData.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

/// Verwaltet die Projektdaten und stellt diese als ObservableObject zur Verfügung.
class TimerData: ObservableObject {
    @Published var projects: [TimerProject] = []
    @Published var deviceSettings = DeviceSettings() // Annahme: DeviceSettings ist anderweitig definiert.
    
    var supabaseDataStore = SupabaseDataStore()
    var localDataStore = LocalDataStore()
    var userId : UUID?
    
    func add(_ project: TimerProject) {
        projects.append(project)
    }
    
    func remove(_ project: TimerProject) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects.remove(at: index)
        }
    }
}
