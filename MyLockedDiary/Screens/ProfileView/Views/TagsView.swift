//
//  TagsView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct TagsView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("TagsView")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    TagsView()
        .environmentObject(MainTabViewViewModel())

}
