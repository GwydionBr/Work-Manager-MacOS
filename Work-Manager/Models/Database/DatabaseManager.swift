////
////  Database.swift
////  WG-Manager
////
////  Created by Gwydion Braunsdorf on 28.01.25.
////
//
//import Foundation
//import Supabase
//
//enum Table {
//    static let features = "Features"
//    static let profiles = "Profiles"
//}
//
//@MainActor
//final class DatabaseManager: ObservableObject {
//    let supabase: SupabaseClient
//    
//    @Published var features = [Feature]()
//    @Published var profile : Profile
//    
//    init(_ supabase: SupabaseClient) {
//        self.supabase = supabase
//        self.profile = Profile(id: UUID(), username: "", fullName: "", avatarURL: "", email: "", birthday: nil)
//    }
//    
//    func fetchData() async {
//        do {
//            try await fetchProfile()
//        } catch {
//            print("❌ Error: \(error)")
//        }
//    }
//    
//    // MARK: - Profile Requests
//    
//    func createProfile(username: String, avatarURL: String?) async throws {
//        let user = try await supabase.auth.session.user
//        
//        let profile = Profile(id: user.id, username: username, fullName: nil, avatarURL: avatarURL ?? nil, email: user.email ?? "", birthday: nil)
//        
//        try await supabase
//            .from(Table.profiles)
//            .insert(profile)
//            .execute()
//    }
//    
//    func fetchProfile() async throws {
//        let user = try await supabase.auth.session.user
//        
//        let profile: [Profile] = try await supabase
//            .from(Table.profiles)
//            .select()
//            .eq("id", value: user.id)
//            .execute()
//            .value
//        
//        
//        print(profile)
//        
//        DispatchQueue.main.async {
//            self.profile = profile[0]
//        }
//    }
//    
//    func updateProfile(_ profile: Profile) async {
//        do {
//            try await supabase
//                .from(Table.profiles)
//                .update(profile)
//                .eq("id", value: profile.id)
//                .execute()
//        } catch {
//            print("❌ Error: \(error)")
//        }
//    }
//    
//    func deleteProfile() async throws {
//        let user = try await supabase.auth.session.user
//        
//        try await supabase
//            .from(Table.profiles)
//            .delete()
//            .eq("id", value: user.id)
//            .execute()
//    }
//    
//    // MARK: - Feature Requests
//        
//    func createFeatureRequest(text: String) async throws {
//        let user = try await supabase.auth.session.user
//        
//        let feature = Feature(createdAt: Date(), text: text, isComplete: false, userID: user.id)
//        
//        try await supabase
//            .from(Table.features)
//            .insert(feature)
//            .execute()
//    }
//    
//    func fetchFeatureRequests() async throws {
//        let features: [Feature] = try await supabase
//            .from(Table.features)
//            .select()
//            .order("created_at", ascending: false)
//            .execute()
//            .value
//        
//        DispatchQueue.main.async {
//            self.features = features
//        }
//    }
//    
//    func updateFeature(_ feature: Feature, with text: String) async {
//        guard let id = feature.id else {
//            print("❌ Can't update feature \(String(describing: feature.id))")
//            return
//        }
//        
//        var toUpdate = feature
//        toUpdate.text = text
//        
//        do {
//            try await supabase
//                .from(Table.features)
//                .update(toUpdate)
//                .eq("id", value: id)
//                .execute()
//        } catch {
//            print("❌ Error: \(error)")
//        }
//    }
//    
//    func deleteFeature(at id: Int) async throws {
//        try await supabase
//            .from(Table.features)
//            .delete()
//            .eq("id", value: id)
//            .execute()
//    }
//}
