//
//  SessionRow.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct SessionRow: View {
    @Binding var session: TimerSession
    
    var body: some View {
        HStack {
            Text(session.getDate())
            Text(session.getEarnedMoney())
        }
    }
}

#Preview {
    SessionRow(session: .constant(TimerData().projects[0].sessions[0]))
}
