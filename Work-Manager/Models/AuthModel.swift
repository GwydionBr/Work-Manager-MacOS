//
//  ViewModel.swift
//  WG-Manager
//
//  Created by Gwydion Braunsdorf on 26.01.25.
//

import Foundation
import Supabase

enum AuthAction: String, CaseIterable {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}

@MainActor
final class AuthModel: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var authAction: AuthAction = .signUp
    
    @Published var showingAuthView = false
    @Published var email = ""
    @Published var password = ""
    @Published var userId : UUID?
    
    init() {
    }
    
    // MARK: - Authentication
    
    func signUp() async throws {
        let _ = try await supabase.auth.signUp(email: email, password: password)
        await isUserAuthenticated()
    }
    
    func signIn() async throws {
        let _ = try await supabase.auth.signIn(email: email, password: password)
        await isUserAuthenticated()
    }
    
    func signInWithGitHub() async throws {
        let redirectURL = URL(string: "wg-manger://auth/callback")!
        let _ = try await supabase.auth.signInWithOAuth(provider: .github, redirectTo: redirectURL)
        await isUserAuthenticated()
    }
    
    func signOut() async throws {
        try await supabase.auth.signOut()
        isAuthenticated = false
    }
    
    func isUserAuthenticated() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        do {
            _ = try await supabase.auth.session.user
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
        isLoading = false
    }
    
    func authorize() async throws {
        switch authAction {
        case .signUp:
            try await signUp()
        case .signIn:
            try await signIn()
        }
    }
}
