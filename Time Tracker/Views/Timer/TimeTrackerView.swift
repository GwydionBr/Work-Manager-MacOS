//
//  TimeTracker.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct TimeTrackerView: View {
    @EnvironmentObject var timerData: TimerData
    @EnvironmentObject var timeTracker: TimeTracker
    @Binding var project: TimerProject
    
    init(project: Binding<TimerProject>) {
        self._project = project
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("\(timeTracker.activeTime)")
                    .font(.largeTitle)
                    .onChange(of: timeTracker.activeTime) { oldValue, newValue in
                        // Menüleiste aktualisieren
                        if let appDelegate = NSApp.delegate as? AppDelegate {
                            appDelegate.updateStatusBar(with: newValue)
                        }
                    }
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

#Preview {
    TimeTrackerView(project: .constant(TimerData().getStaticProject()))
        .environmentObject(TimerData())
}
