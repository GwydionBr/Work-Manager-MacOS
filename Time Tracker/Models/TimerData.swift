//
//  TimerData.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

class TimerData: ObservableObject {
    @Published var projects: [TimerProject] = [
        TimerProject(title: "Argon", description: "🇩🇪 German 🇩🇪", salary: 30.0, currency: "$", sessions: [
            TimerSession(activeTime: 300, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 30.0),
            TimerSession(activeTime: 500, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 30.0),
        ]),
        TimerProject(title: "Hera", description: "Evaluate 2 AI Responses", salary: 16.0, currency: "$", sessions: [
            TimerSession(activeTime: 300, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 16.0),
            TimerSession(activeTime: 500, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 16.0),
        ]),
        TimerProject(title: "Tango", description: "Rate responses as safe / unsafe", salary: 26.0, currency: "$", sessions: [
            TimerSession(activeTime: 300, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 26.0),
            TimerSession(activeTime: 500, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 26.0),
        ]),
        TimerProject(title: "Sia", description: "Evaluate AI Responses", salary: 33.0, currency: "€", sessions: [
            TimerSession(activeTime: 300, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 33.0),
            TimerSession(activeTime: 500, pausedTime: 0, startTime: Date(), endTime: Date(), salary: 33.0),
        ]),
    ]
    
    @Published var settings = TimerSettings()
    @Published var sortFavorites = true
    @Published var sortSalary = false
    @Published var sortName = false
    
    func add(_ project: TimerProject) {
        projects.append(project)
    }
    
    func remove(_ project: TimerProject) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects.remove(at: index)
        }
    }
    
    func sortProjects() -> Binding<[TimerProject]> {
        Binding<[TimerProject]>(
            get: {
                switch self.settings.filter {
                case self.settings.filterOptions[0]:
                    return self.sortedProjectFavorite().wrappedValue
                case self.settings.filterOptions[1]:
                    return self.sortedProjectName().wrappedValue
                case self.settings.filterOptions[2]:
                    return self.sortedProjectSalary().wrappedValue
                default:
                    return self.projects
                }
//                if self.sortFavorites {
//                    return self.sortedProjectFavorite().wrappedValue
//                } else if self.sortSalary {
//                    return self.sortedProjectSalary().wrappedValue
//                } else if self.sortName {
//                    return self.sortedProjectName().wrappedValue
//                } else {
//                    return self.projects
//                }
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
    
    
    private static func getTimerProjectsFileURL() throws -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("timerProjects.data")
        }
    
    func load() {
            do {
                let fileURL = try TimerData.getTimerProjectsFileURL()
                let data = try Data(contentsOf: fileURL)
                projects = try JSONDecoder().decode([TimerProject].self, from: data)
                print("Events loaded: \(projects.count)")
            } catch {
                print("Failed to load from file. Backup data used")
            }
        }
    
    func save() {
            do {
                let fileURL = try TimerData.getTimerProjectsFileURL()
                let data = try JSONEncoder().encode(projects)
                try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
                print("Events saved")
            } catch {
                print("Unable to save")
            }
        }
}
