//
//  DiaryLockView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct DiaryLockView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("Diary Lock")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    DiaryLockView()
        .environmentObject(MainTabViewViewModel())

}
