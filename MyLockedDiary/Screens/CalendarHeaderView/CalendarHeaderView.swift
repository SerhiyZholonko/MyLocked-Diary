//
//  CalendarHeaderView.swift
//  MyLockedDiary
//
//  Created by apple on 14.09.2024.
//

import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Query private var notes: [Note]
    @State private var date = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedMonth) {
                    ForEach(months.indices, id: \.self) { index in
                        Text(months[index]).tag(index+1)
                    }
                }
                CalendarView(date: date)
                    .environmentObject(viewModel)
                    .navigationTitle("Calendar")
                Spacer()
            }
            .background(viewModel.getThemeBackgroundColor())

           
        }

    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(for: Note.self)
}
