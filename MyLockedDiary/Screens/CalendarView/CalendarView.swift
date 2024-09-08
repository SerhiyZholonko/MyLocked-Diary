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
    @State private var date = Date.now
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    @State private var selectedDay: Date?

    var body: some View {
        NavigationStack {
        VStack {
            // DatePicker that updates based on selected day
            LabeledContent("Date") {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
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
                            .onTapGesture {
                                // Update the selected day and date
                                selectedDay = day
                                date = day // Update the DatePicker
                            }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(viewModel.getThemeBackgroundColor())
        
        // Detect swipe gesture
        .gesture(
            DragGesture()
                .onEnded { value in
                        if value.translation.width < 0 {
                            // Swipe left (next month)
//                            withAnimation(.easeIn) {
                                changeMonth(by: 1)
//                            }
                        } else if value.translation.width > 0 {
                            // Swipe right (previous month)
//                            withAnimation(.easeOut) {
                                changeMonth(by: -1)
//                            }
                    }
                }
        )

        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) { _, _ in
            days = date.calendarDisplayDays
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Calendar")
    }
    }

    // Function to change month by a certain amount
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: date) {
            date = newDate
        }
    }
}



#Preview {
    CalendarView()
        .environmentObject(MainTabViewViewModel())

       
}
