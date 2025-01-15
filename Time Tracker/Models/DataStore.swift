//
//  DataStore.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 13.01.25.
//

import Foundation


struct SupabaseDataStore {
    func load() async throws -> [TimerProject] {
        try await supabase!
            .from("timerProject")
            .select("""
                id,
                title,
                description,
                salary,
                currency,
                isFavorite,
                timerSession (
                    id,
                    activeSeconds,
                    pausedSeconds,
                    startTime,
                    endTime,
                    salary,
                    currency,
                    projectId
                )
                """)
            .execute()
            .value
        
    }
    
    func insertProject(_ project: TimerProject) async throws -> TimerProject {
        try await supabase!
            .from("timerProject")
            .insert(project)
            .select()
            .single()
            .execute()
            .value
    }
    
    func insertSession(_ session: TimerSession) async throws -> TimerSession {
       try await supabase!
            .from("timerSession")
            .insert(session)
            .select()
            .single()
            .execute()
            .value
    }
}


// MARK: - Local Data Store

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
