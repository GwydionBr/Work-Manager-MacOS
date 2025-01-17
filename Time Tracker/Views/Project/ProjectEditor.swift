//
//  ProjectEditor.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI
import Combine

struct ProjectEditor: View {
    @Binding var project: TimerProject
    @State var isNew = false
    
    let currencies = ["$", "€", "£", "¥"]
    @State private var hourlyRateInput: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Project Details")) {
                TextField("Title", text: $project.title)
                TextField("Description", text: $project.description)
                
                Picker("Currency", selection: $project.currency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }
                
                
                TextField("Hourly Rate", value: $project.salary, format: .number)
            }
        }
        .padding()
        .frame(width: 400, height: 250)
    }
}


#Preview {
    ProjectEditor(project: .constant(TimerProject()), isNew: true)
}
