//
//  SessionList.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct SessionList: View {
    @ObservedObject var timerData: TimerData
    @Binding var project: TimerProject

    @State private var expandedMonths: Set<Int> = []
    @State private var expandedDays: Set<Date> = []

    // Helper function to generate the grouped sessions
    var groupedSessions: [Int: [Int: [Int: [Date: [TimerSession]]]]]? {
        Dictionary(grouping: project.timerSession ?? []) { session in
            Calendar.current.component(.year, from: session.startTime)
        }.mapValues { sessionsByYear in
            Dictionary(grouping: sessionsByYear) { session in
                Calendar.current.component(.month, from: session.startTime)
            }.mapValues { sessionsByMonth in
                Dictionary(grouping: sessionsByMonth) { session in
                    Calendar.current.component(.weekOfYear, from: session.startTime)
                }.mapValues { sessionsByWeek in
                    Dictionary(grouping: sessionsByWeek) { session in
                        Calendar.current.startOfDay(for: session.startTime)
                    }
                }
            }
        }
    }

    var body: some View {
        if project.timerSession != nil && project.timerSession != [] {
            List {
                if let sessions = groupedSessions {
                    // Iteriere über Jahre
                    ForEach(sessions.keys.sorted(), id: \.self) { year in
                        yearSection(year: year, sessions: sessions[year] ?? [:])
                    }
                }
            }
            .onAppear {
                expandCurrentMonthAndDay()
            }
        }
        else {
            Text("No Sessions")
        }
    }

    // Helper function to handle Year Section
    private func yearSection(year: Int, sessions: [Int: [Int: [Date: [TimerSession]]]]) -> some View {
        Section(header: Text("\(year)".trimmingCharacters(in: .punctuationCharacters))) {
            // Iteriere über Monate innerhalb des Jahres
            ForEach(sessions.keys.sorted(), id: \.self) { month in
                monthDisclosureGroup(month: month, sessions: sessions[month] ?? [:], year: year)
            }
        }
    }

    // Helper function to handle Month DisclosureGroup
    private func monthDisclosureGroup(month: Int, sessions: [Int: [Date: [TimerSession]]], year: Int) -> some View {
        DisclosureGroup(isExpanded: Binding(
            get: { expandedMonths.contains(month) },
            set: { isOpen in
                if isOpen {
                    expandedMonths.insert(month)
                } else {
                    expandedMonths.remove(month)
                }
            }
        )) {
            // Iteriere über Wochen innerhalb des Monats
            ForEach(sessions.keys.sorted(), id: \.self) { week in
                weekSection(week: week, sessions: sessions[week] ?? [:], year: year, month: month)
            }
        } label: {
            Text("\(formattedMonth(month))")
                .foregroundColor(.blue)
                .contentShape(Rectangle())
                .padding(.vertical, 10)
                .onTapGesture {
                    withAnimation {
                        toggleMonthExpansion(month: month)
                    }
                }
        }
    }

    // Helper function to handle Week Section
    private func weekSection(week: Int, sessions: [Date: [TimerSession]], year: Int, month: Int) -> some View {
        Section(header: Text("Week \(week)").foregroundColor(.orange).padding(.vertical, 10)) {
            // Iteriere über Tage innerhalb der Woche
            ForEach(sessions.keys.sorted(), id: \.self) { day in
                dayDisclosureGroup(day: day, sessions: sessions[day] ?? [], year: year, month: month, week: week)
            }
        }
    }

    // Helper function to handle Day DisclosureGroup
    private func dayDisclosureGroup(day: Date, sessions: [TimerSession], year: Int, month: Int, week: Int) -> some View {
        let normalizedDay = Calendar.current.startOfDay(for: day)

        return DisclosureGroup(isExpanded: Binding(
            get: { expandedDays.contains(normalizedDay) },
            set: { isOpen in
                if isOpen {
                    expandedDays.insert(normalizedDay)
                } else {
                    expandedDays.remove(normalizedDay)
                }
            }
        )) {
            // Zeige Sessions des Tages
            ForEach(sessions, id: \.id) { session in
                SessionRow(session: Binding(
                    get: { session },
                    set: { updatedSession in
                        if let index = project.timerSession!.firstIndex(where: { $0.id == session.id }) {
                            project.timerSession?[index] = updatedSession
                        }
                    }
                ))
            }
        } label: {
            Text("\(formattedDate(normalizedDay))")
                .contentShape(Rectangle())
                .padding(.vertical, 10)
                .onTapGesture {
                    withAnimation {
                        toggleDayExpansion(day: normalizedDay)
                    }
                }
        }
    }

    // Helper function to toggle Month expansion
    private func toggleMonthExpansion(month: Int) {
        if expandedMonths.contains(month) {
            expandedMonths.remove(month)
        } else {
            expandedMonths.insert(month)
        }
    }

    // Helper function to toggle Day expansion
    private func toggleDayExpansion(day: Date) {
        let normalizedDay = Calendar.current.startOfDay(for: day)
        if expandedDays.contains(normalizedDay) {
            expandedDays.remove(normalizedDay)
        } else {
            expandedDays.insert(normalizedDay)
        }
    }

    // Helper function to format dates
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Helper function to format months
    func formattedMonth(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.monthSymbols[month - 1]
    }

    // Expand the current month and day
    func expandCurrentMonthAndDay() {
        let today = Calendar.current.startOfDay(for: Date())
        let currentMonth = Calendar.current.component(.month, from: today)

        // Expand the current month
        expandedMonths.insert(currentMonth)

        // Find all sessions for today and expand the day if found
        if ((project.timerSession?.contains(where: { Calendar.current.isDate($0.startTime, inSameDayAs: today) })) != nil) {
            expandedDays.insert(today)
        }
    }
}



#Preview {
    SessionList(timerData: TimerData(),project: .constant(TimerData().projects[0]))
}
