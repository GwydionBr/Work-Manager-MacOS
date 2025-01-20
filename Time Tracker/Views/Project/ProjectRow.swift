//
//  ProjectRow.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct ProjectRow: View {
    @EnvironmentObject var timerData: TimerData
    @Binding var project: TimerProject
    
    @State private var showingDeleteConfirmation = false
    @State private var isHovered = false

    var body: some View {
        VStack{
            HStack {
                FavoriteButton(isSet: $project.isFavorite)
                    .font(.title)
                    .onChange(of: project.isFavorite) {
                        Task {
                            await timerData.updateProject(TimerProjectChanges(id: project.id, isFavorite: project.isFavorite))
                        }
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(project.title)
                        .fontWeight(.bold)
                    Text("\(project.getSalary()) \(project.currency)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(role: .destructive) {
                    // Bestätigungs-Alert anzeigen
                    showingDeleteConfirmation = true
                } label: {
                    Label("", systemImage: "trash")
                        .labelStyle(.iconOnly)
                        .foregroundColor(isHovered ? .red : .clear)
                }
                .background(Color.clear)
                .padding(.horizontal, 10)
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showingDeleteConfirmation) { // Alert anzeigen
                    Alert(
                        title: Text("Do you really want to delete the project?"),
                        message: Text("This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            // Projekt löschen
                            Task {
                                await timerData.deleteProject(project)                        }
                            showingDeleteConfirmation = false // Zustand zurücksetzen
                        },
                        secondaryButton: .cancel {
                            showingDeleteConfirmation = false // Zustand zurücksetzen
                        }
                    )
                }
            }
            .onHover { hovering in
                if !showingDeleteConfirmation {
                    isHovered = hovering
                }
            }
            Divider()
        }
    }
}


#Preview {
    ProjectRow(project: .constant(TimerData().getStaticProject()))
        .environmentObject(TimerData())
}
