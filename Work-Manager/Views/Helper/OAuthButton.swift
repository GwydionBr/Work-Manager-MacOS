//
//  OAuthButton.swift
//  WG-Manager
//
//  Created by Gwydion Braunsdorf on 26.01.25.
//

import SwiftUI

enum OAuthProvider: String {
    case github = "github"
}

struct OAuthButton: View {
    
    let provider: OAuthProvider
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Hintergrundfarbe
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? Color.white : Color.black)
                .frame(height: 50)
            
            // Inhalt des Buttons
            HStack {
                Image("\(provider.rawValue)-\(colorScheme == .dark ? "black" : "white")")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Spacer() // Platzhalter für flexiblen Abstand
                
                Text("Sign in with \(provider.rawValue.capitalized)")
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Spacer() // Platzhalter für flexiblen Abstand
            }
            .padding(.horizontal, 20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(colorScheme == .dark ? .black : .white, lineWidth: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    OAuthButton(provider: .github)
}
