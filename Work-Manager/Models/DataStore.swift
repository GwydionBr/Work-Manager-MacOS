//
//  DataStore.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 13.01.25.
//

import Foundation
import Supabase

enum Table {
    static let timerProject = "timerProject"
    static let timerSession = "timerSession"
}

struct SupabaseDataStore {
    
    func load() async throws -> [TimerProject] {
        let user = try await supabase.auth.session.user
        print(user.id)
        
        let projects: [TimerProject] = try await supabase
            .from(Table.timerProject)
            .select("""
                id,
                title,
                description,
                salary,
                currency,
                is_favorite,
                user_id,
                timerSession (
                    id,
                    active_seconds,
                    paused_seconds,
                    start_time,
                    end_time,
                    salary,
                    currency,
                    project_id,
                    user_id
                )
                """)
            .eq("user_id", value: user.id)
            .execute()
            .value
        
        return projects
    }
    
    func insertProject(_ project: TimerProject) async throws -> TimerProject {
        try await supabase
            .from(Table.timerProject)
            .insert(project)
            .select()
            .single()
            .execute()
            .value
    }
    
    func insertSession(_ session: TimerSession) async throws -> TimerSession {
       try await supabase
            .from(Table.timerSession)
            .insert(session)
            .select()
            .single()
            .execute()
            .value
    }
    
    
    func deleteProject(_ project: TimerProject) async throws {
        try await supabase
            .from(Table.timerSession)
            .delete()
            .eq("projectId", value: project.id)
            .execute()
        
        try await supabase
            .from(Table.timerProject)
            .delete()
            .eq("id", value: project.id)
            .execute()
    }
    
    func deleteSession(_ session: TimerSession) async throws {
        try await supabase
            .from(Table.timerSession)
            .delete()
            .eq("id", value: session.id)
            .execute()
    }
    
    
    func updateProject(_ project: TimerProjectChanges) async throws {
        try await supabase
            .from(Table.timerProject)
            .update(project)
            .eq("id", value: project.id)
            .single()
            .execute()
            .value
    }
    
    func updateSession(_ session: TimerSessionChanges) async throws -> TimerSession {
        try await supabase
            .from(Table.timerSession)
            .update(session)
            .eq("id", value: session.id)
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
