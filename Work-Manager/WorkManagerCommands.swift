//
//  WorkManagerCommands.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 15.01.25.
//

import SwiftUI

struct WorkManagerCommands: Commands {
    var body: some Commands {
        SidebarCommands()
        CommandMenu("Work") {
            Button("Add Project") {
                print("Add Project")
            }
            Button("Add Timer") {
                print("Add Timer")
            }
        }
    }
}
