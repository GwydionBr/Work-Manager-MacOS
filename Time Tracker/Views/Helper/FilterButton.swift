//
//  FilterButton.swift
//  Time Tracker
//
//  Created by Gwydion Braunsdorf on 07.01.25.
//

import SwiftUI

struct FilterButton: View {
    @ObservedObject var timerData: TimerData
    
    @State private var selectedFilter: String = "Favorites"
    let filters = ["Favorites", "Salary", "Name"]
    
    var body: some View {
        HStack{
            Spacer()
            VStack (alignment: .leading){
                // Filter Menu
                Menu {
                    ForEach($timerData.settings.filterOptions, id: \.self) { $filter in
                        Button(filter) {
                            timerData.settings.filter = filter
                            selectedFilter = filter
                        }
                    }
//                    Button("Favorites") {
//                        timerData.sortFavorites = true
//                        timerData.sortSalary = false
//                        timerData.sortName = false
//                        selectedFilter = "Favorites"
//                    }
//                    Button("Salary") {
//                        timerData.sortFavorites = false
//                        timerData.sortSalary = true
//                        timerData.sortName = false
//                        selectedFilter = "Salary"
//                    }
//                    Button("Name") {
//                        timerData.sortFavorites = false
//                        timerData.sortSalary = false
//                        timerData.sortName = true
//                        selectedFilter = "Name"
//                    }
                } label: {
                    Label("\(selectedFilter)", systemImage: "line.horizontal.3.decrease.circle")
                }
                
                
            }
            .padding()
        }
    }
}


#Preview {
    FilterButton(timerData: TimerData())
}
