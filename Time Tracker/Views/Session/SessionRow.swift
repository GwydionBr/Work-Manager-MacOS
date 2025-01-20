//
//  SessionRow.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct SessionRow: View {
    @EnvironmentObject var timerData: TimerData
    @Binding var session: TimerSession
    
    @State private var showingDeleteConfirmation = false
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Spacer()
            Text(session.getTimeSpan())
            VStack {
                Text(formatTimerSeconds(session.activeSeconds))
                    .font(.headline)
                Text("active")
                    .font(.subheadline)
            }
            .padding(.horizontal, 10)
            VStack {
                Text(formatTimerSeconds(session.pausedSeconds))
                    .font(.headline)
                Text("paused")
                    .font(.subheadline)
            }
            .padding(.horizontal, 10)
            
            Text(
                session.currency == "$" ? "$ \(session.getEarnedMoney())" : "\(session.getEarnedMoney()) \(session.currency)"
            )
            .padding(.horizontal, 10)
            
            Button(role: .destructive) {
                // Bestätigungs-Alert anzeigen
                showingDeleteConfirmation = true
            } label: {
                DeleteButton()
                    .foregroundColor(isHovered ? .red : .clear)
            }
            .background(Color.clear)
            .buttonStyle(PlainButtonStyle())
            .alert(isPresented: $showingDeleteConfirmation) { // Alert anzeigen
                Alert(
                    title: Text("Do you really want to delete the session?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        // Projekt löschen
                        Task {
                            await timerData.deleteSession(session)
                        }
                        showingDeleteConfirmation = false // Zustand zurücksetzen
                    },
                    secondaryButton: .cancel {
                        showingDeleteConfirmation = false // Zustand zurücksetzen
                    }
                )
            }
            Spacer()
        }
        .padding()
        .onHover { hovering in
            if !showingDeleteConfirmation {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    SessionRow(session: .constant(TimerData().getStaticSession()))
}
