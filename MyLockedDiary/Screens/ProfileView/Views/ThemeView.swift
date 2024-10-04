//
//  ThemeView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct ThemeView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("ThemeView")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    ThemeView()
        .environmentObject(MainTabViewViewModel())
}
