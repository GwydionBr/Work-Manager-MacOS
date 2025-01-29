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
    
    
    var body: some View {
        VStack {
            Text("\(timeTracker.projectTitle)")
                .font(.title)
            
            
            VStack {
                Text("\(timeTracker.activeTime)")
                    .font(.largeTitle)
                    .onChange(of: timeTracker.activeTime) { oldValue, newValue in
                        // Menüleiste aktualisieren
                        if let appDelegate = NSApp.delegate as? AppDelegate {
                            appDelegate.updateStatusBarText(with: newValue)
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
            Text("\(timeTracker.moneyEarned) \(timeTracker.currency)")
                .padding()
            
            switch timeTracker.state {
                
            case .stopped:
                Button {
                    timeTracker.startTimer()
                } label: {
                    TimerButtonLayout(type: .start)
                }
                .background(Color.clear)
                .buttonStyle(PlainButtonStyle())
                .padding()
            case .running:
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
                        if let newSession = timeTracker.stopTimer() {
                            Task {
                                await timerData.addSession(newSession)
                            }
                        }
                    } label: {
                        TimerButtonLayout(type: .stop)
                    }
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    Spacer()
                }
            case .paused:
                Button {
                    timeTracker.resumeTimer()
                } label: {
                    TimerButtonLayout(type: .start)
                }
                .background(Color.clear)
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            if timeTracker.state != .stopped {
                Button {
                    timeTracker.cancelTimer()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding(5)
                }
                .padding(.top, 25)
            }
        }
    }
}

#Preview {
    TimeTrackerView(project: .constant(TimerData.getStaticProject()))
        .environmentObject(TimerData())
        .environmentObject(TimeTracker())
}
