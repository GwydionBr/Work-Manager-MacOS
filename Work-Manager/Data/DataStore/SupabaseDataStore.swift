//
//  SupabaseDataStore.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 08.02.25.
//

import Foundation
import Supabase

enum Table {
    static let timerProject = "timerProject"
    static let timerSession = "timerSession"
}

/// Verwaltet alle Supabase-CRUD-Operationen.
struct SupabaseDataStore {
    
    func load() async throws -> [TimerProject] {
        let user = try await supabase.auth.session.user
        
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
