//
//  TimerButton.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

enum ButtonType {
    case start, stop, pause, continueAction
}

// TimerButton View
struct TimerButtonLayout: View {
    
    var actionOptions = [
        ButtonType.start: "play.fill",
        ButtonType.stop: "stop.fill",
        ButtonType.pause: "pause.fill",
    ]
    var type: ButtonType
    
    
    var body: some View {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 5)
                    .offset(x: type == .start ? -5 : 0)
                
                Image(systemName: actionOptions[type]!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
        }
    }
}

#Preview {
    TimerButtonLayout(type: .start)
}
