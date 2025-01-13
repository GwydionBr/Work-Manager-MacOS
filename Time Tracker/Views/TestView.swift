//
//  TestView.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 13.01.25.
//

import SwiftUI

struct TestView: View {
    @State var timerProjects: [TimerProject] = []
    
    var body: some View {
        List(timerProjects) { data in
            Text(data.title + " - " + data.description)
        }
        .overlay {
            if timerProjects.isEmpty {
                ProgressView()
            }
        }
        .task {
            do {
                timerProjects = try await supabase!
                    .from("timerProject")
                    .select("""
                        id,
                        title,
                        description,
                        salary,
                        currency,
                        isFavorite,
                        timerSession (
                            id,
                            activeSeconds,
                            pausedSeconds,
                            startTime,
                            endTime,
                            salary,
                            currency
                        )
                        """)
                    .execute()
                    .value
                print(timerProjects)
            } catch {
                dump(error)
            }
        }
    }
}

#Preview {
    TestView()
}
