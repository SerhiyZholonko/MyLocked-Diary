//
//  SettingsView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
            Text("SettingsView")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    NotificationsView()
        .environmentObject(MainTabViewViewModel())
}
