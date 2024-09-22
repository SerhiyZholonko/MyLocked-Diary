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
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                    Picker("", selection: $selectedMonth) {
                                       ForEach(months.indices, id: \.self) { index in
                                           Text(months[index]).tag(index+1)
                                       }
                                   }
                }
                .buttonStyle(.bordered)
               
                CalendarView(date: monthDate, notes: notes)
                    .environmentObject(viewModel)
                    .navigationTitle("Calendar")
                Spacer()
            }
            .background(viewModel.getThemeBackgroundColor())

           
        }
        .onAppear {
            years = Array(Set(notes.map{$0.date.yearInt}.sorted()))
        }
        .onChange(of: selectedYear) {
            updateDate()
        }
        .onChange(of: selectedMonth) {
            updateDate()
        }
    }
    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents( year: selectedYear, month: selectedMonth, day: 1))!
    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(for: Note.self)
}
