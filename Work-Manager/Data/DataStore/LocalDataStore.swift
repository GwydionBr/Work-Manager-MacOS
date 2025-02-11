//
//  LocalDataStore.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import Foundation

/// Verwaltet den lokalen Datei-basierten Datenspeicher.
struct LocalDataStore {
    
    private func getTimerProjectsFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("test1.data")
    }
    
    func load() async throws -> [TimerProject] {
        let fileURL = try getTimerProjectsFileURL()
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([TimerProject].self, from: data)
    }
    
    func save(projects: [TimerProject]) async throws {
        let fileURL = try getTimerProjectsFileURL()
        let data = try JSONEncoder().encode(projects)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
