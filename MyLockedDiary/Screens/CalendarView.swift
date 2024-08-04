//
//  CalendarView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel

    var body: some View {
        Text("Calendar")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    CalendarView()
        .environmentObject(MainTabViewViewModel())

       
}
