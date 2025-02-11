//
//  TimerData+Sorting.swift.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import SwiftUI

// MARK: - Sorting Functions
extension TimerData {
    
    /// Liefert eine Binding-Variable mit sortierten Projekten basierend auf den aktuellen Geräte-Einstellungen.
    func sortProjects() -> Binding<[TimerProject]> {
        Binding<[TimerProject]>(
            get: {
                switch self.deviceSettings.filter {
                case self.deviceSettings.filterOptions[0]:
                    return self.sortedProjectFavorite().wrappedValue
                case self.deviceSettings.filterOptions[1]:
                    return self.sortedProjectName().wrappedValue
                case self.deviceSettings.filterOptions[2]:
                    return self.sortedProjectSalary().wrappedValue
                default:
                    return self.projects
                }
            },
            set: { self.projects = $0 }
        )
    }
    
    func sortedProjectName() -> Binding<[TimerProject]> {
        Binding<[TimerProject]>(
            get: { self.projects.sorted { $0.title < $1.title } },
            set: { self.projects = $0 }
        )
    }
    
    func sortedProjectFavorite() -> Binding<[TimerProject]> {
        Binding<[TimerProject]>(
            get: { self.projects.sorted { $0.isFavorite && !$1.isFavorite } },
            set: { self.projects = $0 }
        )
    }
    
    func sortedProjectSalary() -> Binding<[TimerProject]> {
        Binding<[TimerProject]>(
            get: { self.projects.sorted { $0.salary > $1.salary } },
            set: { self.projects = $0 }
        )
    }
}
