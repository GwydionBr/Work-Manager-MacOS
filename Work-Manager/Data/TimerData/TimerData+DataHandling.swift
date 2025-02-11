//
//  TimerData+DataHandling.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import SwiftUI

// MARK: - Data Handling (CRUD)
extension TimerData {
    
    // MARK: Supabase Data Store
    
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
            await MainActor.run { self.projects.append(response) }
            print("Project saved successfully.")
        } catch {
            print("Failed to save project: \(error)")
        }
    }
    
    func addSession(_ session: TimerSession) async {
        do {
            let response: TimerSession = try await supabaseDataStore.insertSession(session)
            await MainActor.run {
                if let projectIndex = self.projects.firstIndex(where: { $0.id == response.projectId }) {
                    if self.projects[projectIndex].timerSession == nil {
                        self.projects[projectIndex].timerSession = []
                    }
                    self.projects[projectIndex].timerSession?.append(response)
                }
            }
            print("Session saved successfully.")
        } catch {
            print("Failed to save session: \(error)")
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
    
    func updateProject(_ project: TimerProjectChanges) async {
        do {
            if let index = self.projects.firstIndex(where: { $0.id == project.id }) {
                try await supabaseDataStore.updateProject(project)
                await MainActor.run {
                    if let title = project.title { self.projects[index].title = title }
                    if let description = project.description { self.projects[index].description = description }
                    if let salary = project.salary { self.projects[index].salary = salary }
                    if let currency = project.currency { self.projects[index].currency = currency }
                }
            }
            print("Project updated successfully.")
        } catch {
            print("Failed to update project: \(error)")
        }
    }
    
    func updateSession(_ session: TimerSessionChanges) async {
        do {
            let response = try await supabaseDataStore.updateSession(session)
            if let projectIndex = self.projects.firstIndex(where: { $0.id == response.projectId }),
               let sessionIndex = self.projects[projectIndex].timerSession?.firstIndex(where: { $0.id == response.id }) {
                await MainActor.run {
                    self.projects[projectIndex].timerSession?[sessionIndex] = response
                }
            }
            print("Session updated successfully.")
        } catch {
            print("Failed to update session: \(error)")
        }
    }
    
    // MARK: Local Data Store
    
    func setStaticBackupProjects() {
        self.projects = [
            TimerProject(title: "Argon", description: "🇩🇪 German 🇩🇪", salary: 30.0, currency: "$", isFavorite: false, timerSession: [
                TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 30.0, currency: "$"),
                TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 30.0, currency: "$")
            ]),
            TimerProject(title: "Hera", description: "Evaluate 2 AI Responses", salary: 16.0, currency: "$", isFavorite: false, timerSession: [
                TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 16.0, currency: "$"),
                TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 16.0, currency: "$")
            ]),
            TimerProject(title: "Tango", description: "Rate responses as safe / unsafe", salary: 26.0, currency: "$", isFavorite: false, timerSession: [
                TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 26.0, currency: "$"),
                TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 26.0, currency: "$")
            ]),
            TimerProject(title: "Sia", description: "Evaluate AI Responses", salary: 33.0, currency: "€", isFavorite: false, timerSession: [
                TimerSession(activeSeconds: 300, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 33.0, currency: "$"),
                TimerSession(activeSeconds: 500, pausedSeconds: 0, startTime: Date(), endTime: Date(), salary: 33.0, currency: "$")
            ])
        ]
    }
    
    func loadOfflineProjects() async {
        if let savedData = UserDefaults.standard.data(forKey: "projects") {
            do {
                try await MainActor.run {
                    self.projects = try JSONDecoder().decode([TimerProject].self, from: savedData)
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
