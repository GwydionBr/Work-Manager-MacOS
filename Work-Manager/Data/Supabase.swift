//
//  Supabase.swift
//  WG-Manager
//
//  Created by Gwydion Braunsdorf on 28.01.25.
//

import Foundation
import Supabase

let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
