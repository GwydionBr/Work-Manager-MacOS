//
//  Supabase.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 13.01.25.
//

import Foundation
import Supabase

func initializeSupabaseClient() -> SupabaseClient? {
    guard let supabaseURLString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
          let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] else {
        print("Fehler: SUPABASE_URL oder SUPABASE_KEY sind nicht in den Umgebungsvariablen gesetzt.")
        return nil
    }
    
    guard let supabaseURL = URL(string: supabaseURLString) else {
        print("Fehler: Die SUPABASE_URL ist keine gültige URL.")
        return nil
    }
    
    let client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    print("Supabase-Client erfolgreich initialisiert.")
    return client
}

// Initialisierung aufrufen
let supabase = initializeSupabaseClient()




