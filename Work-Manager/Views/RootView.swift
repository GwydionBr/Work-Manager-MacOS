//
//  RootView.swift
//  WG-Manager
//
//  Created by Gwydion Braunsdorf on 26.01.25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var timerData: TimerData
    @EnvironmentObject var timeTracker: TimeTracker

    var body: some View {
        Group {
            if authModel.isAuthenticated {
                ProjectList()
                    .onAppear {
                        Task {
                            await timerData.loadProjects()
                        }
                    }
                    .onDisappear {
                        Task {
                            timerData.saveOfflineProjects()
                            timeTracker.resetTimer()
                        }
                    }
            } else {
                AuthView(authModel: authModel)
            }
        }
        .onAppear {
            Task {
                await authModel.isUserAuthenticated()
            }
        }
        .animation(.easeInOut, value: authModel.isAuthenticated)
    }
}

#Preview {
    RootView()
}
