//
//  WidgetView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct WidgetView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("WidgetView")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    WidgetView()
        .environmentObject(MainTabViewViewModel())

}
