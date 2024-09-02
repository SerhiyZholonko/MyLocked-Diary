//
//  ProfileView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("Profile")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    ProfileView()
        .environmentObject(MainTabViewViewModel())
}
