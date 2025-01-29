//
//  SupabaseManager.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 22.01.25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    private init() {}

    private let supabaseURL = URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"]!)!
    private let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"]!

    lazy var client: SupabaseClient = {
        return SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }()
}
