//
//  CalendarView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @State private var color: Color = .blue
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    @State private var selectedDay: Date?
    var body: some View {
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        selectedDay == day
                                        ? .green.opacity(0.3)
                                        : (Date.now.startOfDay == day.startOfDay
                                           ? .red.opacity(0.3)
                                           : color.opacity(0.3))
                                    )
                            )

                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(viewModel.getThemeBackgroundColor())

        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) { _, _ in
            days = date.calendarDisplayDays
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}



#Preview {
    CalendarView(date: Date.now)
        .environmentObject(MainTabViewViewModel())

       
}
