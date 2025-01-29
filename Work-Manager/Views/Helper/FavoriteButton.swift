//
//  FavoriteButton.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    @State private var isHovered = false
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .scaleEffect(isHovered ? 1.2 : 1.0)
                .foregroundStyle(isSet ? .yellow : .gray)
                .animation(.easeInOut(duration: 0.2), value: isHovered)
        }
        .background(Color.clear) // Hintergrund transparent machen
        .buttonStyle(PlainButtonStyle()) // Button-Style auf "Plain" setzen, um Standard-Hintergrund zu entfernen
        .onHover { hovering in
                    isHovered = hovering
                }
        .animation(.default, value: isSet)
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
