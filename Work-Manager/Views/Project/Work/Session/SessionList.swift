//
//  SessionList.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI
import AppKit

struct SessionList: View {
    @EnvironmentObject var timerData: TimerData
    @Binding var project: TimerProject

    @State private var expandedMonths: Set<Int> = []
    @State private var expandedWeeks: Set<String> = []

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
        if let sessionsAll = project.timerSession, !sessionsAll.isEmpty {
            List {
                if let sessions = groupedSessions {
                    ForEach(sessions.keys.sorted(by: >), id: \.self) { year in
                        Section(header: YearHeaderView(year: year)) {
                            ForEach(sessions[year]!.keys.sorted(by: >), id: \.self) { month in
                                monthDisclosureGroup(month: month, sessions: sessions[year]![month]!, year: year)
                            }
                        }
                        .listRowBackground(Color(NSColor.controlBackgroundColor))
                    }
                }
            }
            .listStyle(DefaultListStyle())
            .onAppear {
                expandCurrentMonthAndWeek()
            }
            .navigationTitle("Sessions")
            .background(Color(NSColor.windowBackgroundColor))
        } else {
            Text("No Sessions")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }

    // MARK: - Custom Header Views
    
    struct YearHeaderView: View {
        let year: Int
        var body: some View {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.accentColor)
                Text(year.formatted(.number.grouping(.never)))
                    .font(.title2)
                    .bold()
            }
            .padding(.vertical, 4)
        }
    }

    private func monthDisclosureGroup(month: Int, sessions: [Int: [Date: [TimerSession]]], year: Int) -> some View {
        DisclosureGroup(
            isExpanded: Binding(
                get: { expandedMonths.contains(month) },
                set: { isOpen in
                    if isOpen {
                        expandedMonths.insert(month)
                    } else {
                        expandedMonths.remove(month)
                    }
                }
            )
        ) {
            ForEach(sessions.keys.sorted(by: >), id: \.self) { week in
                weekDisclosureGroup(week: week, sessions: sessions[week]!, year: year, month: month)
            }
            .padding(.leading, 10)
        } label: {
            HStack {
                Image(systemName: "folder")
                    .foregroundColor(.blue)
                Text(formattedMonth(month))
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }

    private func weekDisclosureGroup(week: Int, sessions: [Date: [TimerSession]], year: Int, month: Int) -> some View {
        let key = "\(year)-\(month)-\(week)"
        return DisclosureGroup(
            isExpanded: Binding(
                get: { expandedWeeks.contains(key) },
                set: { isOpen in
                    if isOpen {
                        expandedWeeks.insert(key)
                    } else {
                        expandedWeeks.remove(key)
                    }
                }
            )
        ) {
            ForEach(sessions.keys.sorted(by: >), id: \.self) { day in
                daySection(day: day, sessions: sessions[day]!, year: year, month: month, week: week)
                    .padding(.leading, 20)
            }
        } label: {
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(.orange)
                Text("Week \(week)")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }

    private func daySection(day: Date, sessions: [TimerSession], year: Int, month: Int, week: Int) -> some View {
        let normalizedDay = Calendar.current.startOfDay(for: day)
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.green)
                Text(formattedDate(normalizedDay))
                    .font(.subheadline)
                Spacer()
            }
            ForEach(sessions.sorted(by: { $0.startTime > $1.startTime }), id: \.id) { session in
                SessionRow(session: Binding(
                    get: { session },
                    set: { updatedSession in
                        if let index = project.timerSession?.firstIndex(where: { $0.id == session.id }) {
                            project.timerSession?[index] = updatedSession
                        }
                    }
                ))
                .listRowBackground(Color(NSColor.windowBackgroundColor))
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - format methods

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func formattedMonth(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.monthSymbols[month - 1]
    }

    func expandCurrentMonthAndWeek() {
        let today = Calendar.current.startOfDay(for: Date())
        let currentYear = Calendar.current.component(.year, from: today)
        let currentMonth = Calendar.current.component(.month, from: today)
        let currentWeek = Calendar.current.component(.weekOfYear, from: today)
        
        expandedMonths.insert(currentMonth)
        let weekKey = "\(currentYear)-\(currentMonth)-\(currentWeek)"
        expandedWeeks.insert(weekKey)
    }
}

#Preview {
    SessionList(project: .constant(TimerData.getStaticProject()))
        .environmentObject(TimerData())
}
