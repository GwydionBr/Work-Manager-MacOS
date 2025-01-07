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

