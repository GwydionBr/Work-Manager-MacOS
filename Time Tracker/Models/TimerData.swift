//
//  TimerData.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

class TimerData: ObservableObject {
    @Published var projects: [TimerProject] = [
    ]
    
    @Published var settings = TimerSettings()
    
    private var supabaseDataStore = SupabaseDataStore()
    private var localDataStore = LocalDataStore()
    
    func add(_ project: TimerProject) {
        projects.append(project)
    }
    
    func remove(_ project: TimerProject) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects.remove(at: index)
        }
    }
}


//MARK: - Sorting Functions


extension TimerData {
    
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


// MARK: - Data Handling


extension TimerData {
    
    // MARK: - Supabase Data Store
    
    func loadProjects() async {
        do {
            let fetchedProjects = try await supabaseDataStore.load()
            await MainActor.run {
                self.projects = fetchedProjects
            }
            print("Online projects loaded: \(projects.count)")
        } catch {
            await loadOfflineProjects()
            print("Failed to load projects: \(error)")
        }
    }
    
    func addProject(_ project: TimerProject) async {
        do {
            let response: TimerProject = try await supabaseDataStore.insertProject(project)
            await MainActor.run {
                self.projects.append(response)
            }
            print("Projects saved successfully.")
        } catch {
            print("Failed to save projects: \(error)")
        }
    }
    
    func deleteProject(_ project: TimerProject) async {
        do {
            try await supabaseDataStore.deleteProject(project)
            await MainActor.run {
                self.projects.removeAll { $0.id == project.id }
            }
            print("Project deleted successfully.")
        } catch {
            print("Failed to delete project: \(error)")
        }
    }
    
    func addSession(_ session: TimerSession) async {
        do {
            let response: TimerSession = try await supabaseDataStore.insertSession(session)
            await MainActor.run {
                if let projectIndex = self.projects.firstIndex(where: { $0.id == response.projectId }) {
                    // Initialisiere `timerSession`, falls es nil ist
                    if self.projects[projectIndex].timerSession == nil {
                        self.projects[projectIndex].timerSession = []
                    }
                    // Füge die neue Session hinzu
                    self.projects[projectIndex].timerSession?.append(response)
                }
            }
            print("Session saved successfully.")
        } catch {
            print("Failed to save session: \(error)")
        }
    }
    
    func deleteSession(_ session: TimerSession) async {
        do {
            try await supabaseDataStore.deleteSession(session)
            await MainActor.run {
                if let projectIndex = self.projects.firstIndex(where: { $0.id == session.projectId }) {
                    self.projects[projectIndex].timerSession?.removeAll { $0.id == session.id }
                }
            }
            print("Session deleted successfully.")
        } catch {
            print("Failed to delete session: \(error)")
        }
    }

    
    // MARK: - Local Data Store
    
    func setStaticBackupProjects () {
        self.projects = [
                TimerProject(title: "Argon", description: "🇩🇪 German 🇩🇪", salary: 30.0, currency: "$", isFavorite: false, timerSession: [
                    TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 30.0, currency: "$"),
                    TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 30.0, currency: "$"),
                ]),
                TimerProject(title: "Hera", description: "Evaluate 2 AI Responses", salary: 16.0, currency: "$", isFavorite: false, timerSession: [
                    TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 16.0, currency: "$"),
                    TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 16.0, currency: "$"),
                ]),
                TimerProject(title: "Tango", description: "Rate responses as safe / unsafe", salary: 26.0, currency: "$", isFavorite: false, timerSession: [
                    TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 26.0, currency: "$"),
                    TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 26.0, currency: "$"),
                ]),
                TimerProject(title: "Sia", description: "Evaluate AI Responses", salary: 33.0, currency: "€", isFavorite: false, timerSession: [
                    TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 33.0, currency: "$"),
                    TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 33.0, currency: "$"),
                ]),
        ]
    }
    
    func loadOfflineProjects() async {
        if let savedData = UserDefaults.standard.data(forKey: "projects") {
            do {
                try await MainActor.run {
                    projects = try JSONDecoder().decode([TimerProject].self, from: savedData)
                }
                print("Offline projects loaded: \(projects.count)")
            } catch {
                setStaticBackupProjects()
                print("Failed to load offline projects: \(error)")
                print("Loaded static backup projects.")
            }
        }
    }
    
    func saveOfflineProjects() {
        do {
            let data = try JSONEncoder().encode(projects)
            UserDefaults.standard.set(data, forKey: "projects")
            print("Projects saved offline.")
        } catch {
            print("Failed to save offline projects: \(error)")
        }
    }
}


// MARK: Static Content for the Preview

extension TimerData {
    
    func getStaticSession () -> TimerSession {
        TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 30.0, currency: "$")
    }
    
    func getStaticProject () -> TimerProject {
        TimerProject(title: "Tango", description: "Rate responses as safe / unsafe", salary: 26.0, currency: "$", isFavorite: false, timerSession: [getStaticSession()])
    }
}
