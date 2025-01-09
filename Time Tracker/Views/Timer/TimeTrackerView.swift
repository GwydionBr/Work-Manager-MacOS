//
//  TimeTracker.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct TimeTrackerView: View {
    @Binding var project: TimerProject
    @StateObject private var timeTracker: TimeTracker
    
    init(project: Binding<TimerProject>) {
        self._project = project
        self._timeTracker = StateObject(wrappedValue: TimeTracker(salary: project.wrappedValue.salary, currency: project.wrappedValue.currency))
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("\(timeTracker.activeTime)")
                    .font(.largeTitle)
                Text("Active Time")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            VStack {
                Text("\(timeTracker.pausedTime)")
                    .font(.title)
                    .foregroundColor(.gray)
                Text("Pause Time")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Text("\(timeTracker.moneyEarned) €")
                .padding()
            
            if !timeTracker.isTimerActive && !timeTracker.isRunning {
                Button {
                    timeTracker.startTimer()
                } label: {
                    TimerButtonLayout(type: .start)
                }
                .background(Color.clear)
                .buttonStyle(PlainButtonStyle())
                .padding()
            } else if timeTracker.isTimerActive && timeTracker.isRunning {
                HStack {
                    Spacer()
                    Button {
                        timeTracker.pauseTimer()
                    } label: {
                        TimerButtonLayout(type: .pause)
                    }
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    Spacer()
                    Button {
                        let newSession = timeTracker.stopTimer()
                        project.sessions.append(newSession)
                        
                    } label: {
                        TimerButtonLayout(type: .stop)
                    }
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    Spacer()
                }
            } else if timeTracker.isTimerActive && !timeTracker.isRunning {
                Button {
                    timeTracker.continueTimer()
                } label: {
                    TimerButtonLayout(type: .start)
                }
                .background(Color.clear)
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
        }
    }
}

#Preview {
    TimeTrackerView(project: .constant(TimerData().projects[0]))
}
