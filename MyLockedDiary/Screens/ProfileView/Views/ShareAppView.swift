//
//  ShareAppView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct ShareAppView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("ShareAppView")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    ShareAppView()
        .environmentObject(MainTabViewViewModel())

}
