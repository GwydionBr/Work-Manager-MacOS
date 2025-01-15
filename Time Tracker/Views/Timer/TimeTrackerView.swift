//
//  TimeTracker.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct TimeTrackerView: View {
    @ObservedObject var timerData: TimerData
    @Binding var project: TimerProject
    @StateObject private var timeTracker: TimeTracker
    
    init(project: Binding<TimerProject>, timerData: ObservedObject<TimerData>) {
        self._project = project
        self._timeTracker = StateObject(wrappedValue: TimeTracker(salary: project.wrappedValue.salary, currency: project.wrappedValue.currency))
        self._timerData = timerData
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
                        var newSession = timeTracker.stopTimer()
                        newSession.projectId = project.id
                        Task {
                            await timerData.addSession(newSession)
                        }
                        
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

//#Preview {
//    TimeTrackerView(project: Binding<TimerProject>, timerData: <#T##StateObject<TimerData>#>)
//}
