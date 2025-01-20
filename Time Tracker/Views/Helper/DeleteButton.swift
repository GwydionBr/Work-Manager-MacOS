//
//  DeleteButton.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 20.01.25.
//

import SwiftUI

struct DeleteButton: View {
    @State private var hovered: Bool = false
    
    var body: some View {
        Label("Delete", systemImage: "trash")
            .labelStyle(.iconOnly)
            .frame(width: 27, height: 27)
            .onHover(perform: { hover in
                self.hovered = hover
            })
            .background(
                Circle()
                    .fill(hovered ? Color.red.opacity(0.1) : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: hovered)
            )
            .overlay(
                Circle()
                    .stroke(hovered ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
                    .animation(.easeInOut(duration: 0.2), value: hovered)
            )
    }
}

#Preview {
    DeleteButton()
}
