////
////  AuthViewModel.swift
////  Time Tracker
////
////  Created by Gwydion Braunsdorf on 22.01.25.
////
//
//import Foundation
//import Supabase
//
//@MainActor
//class AuthViewModel: ObservableObject {
//    @Published var user: User?
//
//    private let client = SupabaseManager.shared.client
//
//    func signUp(email: String, password: String) async throws {
//        let result = try await client.auth.signUp(email: email, password: password)
//        self.user = result.user
//    }
//
//    func signIn(email: String, password: String) async throws {
//        let result = try await client.auth.signIn(email: email, password: password)
//        self.user = result.user
//    }
//
//    func signOut() async throws {
//        try await client.auth.signOut()
//        self.user = nil
//    }
//
//    func getUser() {
//        self.user = client.auth.session.user
//    }
//}
