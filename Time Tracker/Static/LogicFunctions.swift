//
//  LogicFunctions.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import Foundation

func roundToMaxTwoDecimals(number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: number)) ?? ""
}


func formatTimerSeconds(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let seconds = seconds % 60
    
    if hours > 0 {
        // Format mit Stunden
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    } else {
        // Format ohne Stunden
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
