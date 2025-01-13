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
        }
        .padding()
    }
}

#Preview {
    SessionRow(session: .constant(TimerData().projects[0].timerSession[0]))
}
