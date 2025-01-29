//
//  SessionEditor.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 20.01.25.
//

import SwiftUI

struct SessionEditorView: View {
    @Binding var session: TimerSession
    
    var body: some View {
        Form {
            Section(header: Text("Session Details")) {
                TextField("Active Seconds", value: $session.activeSeconds, format: .number)
                TextField("Paused Seconds", value: $session.pausedSeconds, format: .number)
                DatePicker("Start Time", selection: $session.startTime, displayedComponents: [.date, .hourAndMinute])
                TextField("Hourly Rate", value: $session.salary, format: .number)
                Picker("Currency", selection: $session.currency) {
                    ForEach(Constants.Currency.currencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    SessionEditorView(session: .constant(TimerData.getStaticSession()))
}
