//
//  ProjectList.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct ProjectList: View {
    @ObservedObject var timerData: TimerData
    @State private var selection: TimerProject?
    
    @State private var isAddingNewProject = false
    @State private var newProject = TimerProject()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                FilterButton(timerData: timerData)
                ForEach(timerData.sortProjects()) { $project in
                    NavigationLink(destination: ProjectDetail(timerData: timerData, project: $project)) {
                        ProjectRow(timerData: timerData, project: $project)
                    }
                }
            }
            .animation(.default, value: timerData.settings.filter)
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingNewProject = true
                        newProject = TimerProject()
                    } label: {
                        Label("Add project", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewProject) {
                NavigationStack {
                    ProjectEditor(project: $newProject, isNew: true)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isAddingNewProject = false
                                }
                            }
                            ToolbarItem {
                                Button {
                                    timerData.add(newProject)
                                    isAddingNewProject = false
                                } label: {
                                    Text("Add" )
                                }
                                .disabled(newProject.title.isEmpty)
                            }
                        }
                }
            }
        } detail: {
            Text("Select a project")
        }
        
    }
}

#Preview {
    ProjectList(timerData: TimerData())
}
