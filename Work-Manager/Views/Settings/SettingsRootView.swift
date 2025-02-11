//
//  SettingsRootView.swift
//  WorkManager13
//
//  Created by Gwydion Braunsdorf on 06.02.25.
//

import SwiftUI

struct SettingsRootView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        if authModel.isAuthenticated {
            SettingsView()
        } else if authModel.isLoading {
            ProgressView()
        } else {
            Text("Please log in")
            .padding()
        }
    }
}

#Preview {
    SettingsRootView()
}
