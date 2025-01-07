//
//  FavoriteButton.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .yellow : .gray)
        }
        .background(Color.clear) // Hintergrund transparent machen
        .buttonStyle(PlainButtonStyle()) // Button-Style auf "Plain" setzen, um Standard-Hintergrund zu entfernen
        .animation(.default, value: isSet)
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
