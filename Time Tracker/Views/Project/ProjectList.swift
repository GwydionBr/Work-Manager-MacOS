//
//  ProjectList.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct ProjectList: View {
    @EnvironmentObject var timerData: TimerData
    @EnvironmentObject var timeTracker: TimeTracker
    @State private var selection: TimerProject?
    
    @State private var isAddingNewProject = false
    @State private var newProject = TimerProject()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                FilterButton()
                ForEach(timerData.sortProjects()) { $project in
                    NavigationLink(destination: ProjectDetail(project: $project)) {
                        ProjectRow(project: $project)
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
                                    Task{
                                        await timerData.addProject(newProject)
                                        isAddingNewProject = false
                                    }
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
    ProjectList()
        .environmentObject(TimerData())
}
