//
//  TimerDataAnalysis.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 21.01.25.
//

import Foundation

struct TimerDataAnalysis {
    
    
    static func getEarningsPerDay(sessions: [TimerSession]) -> [String: Double] {
            var dailyEarnings: [String: Double] = [:]
            
            for session in sessions {
                let dateKey = session.getDate() // Aggregiere nach Datum
                let earned = Double(session.activeSeconds) * session.salary / 3600
                
                if let currentEarnings = dailyEarnings[dateKey] {
                    dailyEarnings[dateKey] = currentEarnings + earned
                } else {
                    dailyEarnings[dateKey] = earned
                }
            }
            
            return dailyEarnings
        }
    
    static func getEarningsPerMonth(sessions: [TimerSession]) -> [Date: Double] {
        var monthlyEarnings: [Date: Double] = [:]

        for session in sessions {
            // Extrahiere den Monat und das Jahr als Datum
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: session.startTime)
            let monthDate = calendar.date(from: components)!
            
            // Berechne das verdiente Geld
            let earned = Double(session.activeSeconds) * session.salary / 3600
            
            // Summiere die Einnahmen
            if let currentEarnings = monthlyEarnings[monthDate] {
                monthlyEarnings[monthDate] = currentEarnings + earned
            } else {
                monthlyEarnings[monthDate] = earned
            }
            
        }
        return monthlyEarnings
    }
    
    static func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy"
        return formatter.string(from: date)
    }
}
