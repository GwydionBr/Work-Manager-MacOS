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

struct ButtonConfig {
    let image: String
    let color: Color
}

// TimerButton View
struct TimerButtonLayout: View {
    var type: ButtonType
    
    var actionOptions: [ButtonType: ButtonConfig] = [
        .start: ButtonConfig(image: "play.fill", color: .green),
        .stop: ButtonConfig(image: "stop.fill", color: .red),
        .pause: ButtonConfig(image: "pause.fill", color: .orange),
        .continueAction: ButtonConfig(image: "play.fill", color: .green)
    ]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 80, height: 80)
                .shadow(radius: 5)
                .offset(x: type == .start ? -5 : 0)
            
            if let config = actionOptions[type] {
                Image(systemName: config.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(config.color)
            } else {
                Text("Error")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    TimerButtonLayout(type: .start)
}
