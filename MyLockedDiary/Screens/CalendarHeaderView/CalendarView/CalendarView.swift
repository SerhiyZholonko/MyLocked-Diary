//
//  CalendarView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    let date: Date
    let notes: [Note] // Pass the notes from CalendarHeaderView
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
                        .foregroundStyle(.blue)
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
                                        getBackgroundColor(for: day)
//                                            .opacity(0.3)
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
    }
    
    // Helper function to get the color for the day
    func getBackgroundColor(for day: Date) -> Color {
        if let note = notes.first(where: { $0.date.startOfDay == day.startOfDay }) {
            // If there's a note for the day, use its energy color (convert hex to Color)
            return Color.fromHex( note.energyColor)  // Fallback to green if no color is found
        }
        else if selectedDay == day {
            return .green
        } else if Date.now.startOfDay == day.startOfDay {
            return .blue.opacity(0.3)
        } else {
            return .blue.opacity(0.6)
        }
    }
}


#Preview {
    CalendarView(date: Date.now, notes: [])
        .environmentObject(MainTabViewViewModel())
}
