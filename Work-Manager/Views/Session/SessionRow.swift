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
    @State private var isEditingSession = false
    @State private var newSession = TimerSession()
    
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
            
            Button {
                newSession = session
                isEditingSession = true
            } label: {
                EditButton()
                    .foregroundColor(isHovered ? .gray : .clear)
            }
            .buttonStyle(PlainButtonStyle())
            
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
        .sheet(isPresented: $isEditingSession) {
            NavigationStack {
                SessionEditorView(session: $newSession)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEditingSession = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                Task {
                                    await timerData.updateSession(
                                        TimerSessionChanges(
                                            id: newSession.id,
                                            activeSeconds: newSession.activeSeconds,
                                            pausedSeconds: newSession.pausedSeconds,
                                            startTime: newSession.startTime,
                                            endTime: newSession.endTime,
                                            salary: newSession.salary,
                                            currency: newSession.currency,
                                            projectId: newSession.projectId
                                        )
                                    )
                                    isEditingSession = false
                                }
                            }
                        }
                    }
            }
            
        }
    }
}

#Preview {
    SessionRow(session: .constant(TimerData.getStaticSession()))
}
