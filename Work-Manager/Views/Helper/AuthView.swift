//
//  AuthView.swift
//  WG-Manager
//
//  Created by Gwydion Braunsdorf on 26.01.25.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var authModel: AuthModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Titel
                Text("WG-Manager")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                
                Spacer()
                
                Text("Sign up or log in to continue")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Auth-Aktion Picker
                Picker("Sign Up or Sign In", selection: $authModel.authAction) {
                    ForEach(AuthAction.allCases, id: \.rawValue) { action in
                        Text(action.rawValue.capitalized).tag(action)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Eingabefelder
                VStack(spacing: 16) {
                    TextField("Email", text: $authModel.email)
                        .textContentType(.emailAddress)
                        .padding()
                        .cornerRadius(8)
                    
                    Divider()
                    
                    SecureField("Password", text: $authModel.password)
                        .textContentType(.password)
                        .padding()
                        .cornerRadius(8)
                    
                    Divider()
                }
                .padding(.horizontal)
                
                // GitHub OAuth Button
                Button(action: {
                    Task {
                        try await authModel.signInWithGitHub()
                    }
                }) {
                    OAuthButton(provider: .github)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Auth-Aktion Button
                Button(action: {
                    Task {
                        try await authModel.authorize()
                    }
                }) {
                    Text(authModel.authAction.rawValue)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(authModel.authAction == .signIn ? Color.blue : Color.green)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(authModel: AuthModel(supabase))
    }
}
