//
//  ProjectAnalysisView.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 21.01.25.
//

import SwiftUI
import Charts

struct ProjectAnalysisView: View {
    @Binding var project: TimerProject
    
    var body: some View {
        if let sessions = project.timerSession {
            let salaryPerMonth = TimerDataAnalysis.getEarningsPerMonth(sessions: sessions)
            Chart {
                ForEach(salaryPerMonth.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    BarMark(
                        x: .value("Date", TimerDataAnalysis.formatMonth(key)),
                        y: .value("Salary", value)
                    )
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .frame(width: 400, height: 400)
            .chartXAxisLabel("Month", position: .bottom) // X-Achsenbeschriftung
            .chartYAxisLabel("Earnings (€)", position: .leading) // Y-Achsenbeschriftung
            .frame(width: 400, height: 400)
        } else {
            Text("No sessions yet")
        }
    }
}

#Preview {
    ProjectAnalysisView(project: .constant(TimerData.getStaticProject()))
}
