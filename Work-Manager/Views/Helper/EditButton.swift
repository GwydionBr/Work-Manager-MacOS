//
//  EditButton.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 20.01.25.
//

import SwiftUI

struct EditButton: View {
    @State private var hovered: Bool = false
    
    var body: some View {
        Label("Edit", systemImage: "pencil")
            .labelStyle(.iconOnly)
            .frame(width: 27, height: 27) // Einheitliche Größe für den Button
            .onHover(perform: { hover in
                self.hovered = hover
            })
            .background(
                Circle()
                    .fill(hovered ? Color.blue.opacity(0.2) : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: hovered)
            )
            .overlay(
                Circle()
                    .stroke(hovered ? Color.blue.opacity(0.7) : Color.clear, lineWidth: 1)
                    .animation(.easeInOut(duration: 0.2), value: hovered)
            )    }
}

#Preview {
    EditButton()
}
