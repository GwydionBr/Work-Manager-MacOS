//
//  ProjectEditor.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct ProjectEditorView: View {
    @Binding var project: TimerProject
    
    var body: some View {
        Form {
            Section(header: Text("Project Details")) {
                TextField("Title", text: $project.title)
                TextField("Description", text: $project.description)
                TextField("Hourly Rate", value: $project.salary, format: .number)
                
                Picker("Currency", selection: $project.currency) {
                    ForEach(Constants.Currency.currencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }
            }
        }
        .padding()
        .frame(width: 400, height: 250)
    }
}


#Preview {
    ProjectEditorView(project: .constant(TimerProject()))
}
