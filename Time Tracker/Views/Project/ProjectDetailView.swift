//
//  ProjectDetail.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 06.01.25.
//

import SwiftUI

struct ProjectDetailView: View {
    @Binding var project: TimerProject
    
    @State private var selectedTab: Tab = .details // Aktueller Tab

    var body: some View {
        TabView (selection: $selectedTab) {
            ProjectWorkView(project: $project)
                .tag(Tab.details)
                .tabItem {
                    Label("Details", systemImage: "info.circle")
                }
            ProjectAnalysisView(project: $project)
                .tag(Tab.analysis)
                .tabItem {
                    Label("Analysis", systemImage: "chart.pie")
                }
        }
            
    }
}

enum Tab {
    case details
    case analysis
}
    

#Preview {
    ProjectDetailView(project: .constant(TimerData.getStaticProject()))
}
