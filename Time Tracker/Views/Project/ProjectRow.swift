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
    
    @State private var showingDeleteConfirmation = false // @State für den Alert

    var body: some View {
        HStack {
            FavoriteButton(isSet: $project.isFavorite)
                .font(.title)
            
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
                    .foregroundColor(.red)
            }
            .background(Color.clear)
            .buttonStyle(PlainButtonStyle())
            .alert(isPresented: $showingDeleteConfirmation) { // Alert anzeigen
                Alert(
                    title: Text("Do you really want to delete the project?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        // Projekt löschen
                        timerData.remove(project)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


#Preview {
    ProjectRow(project: .constant(TimerData().projects[0]))
        .environmentObject(TimerData())
}
