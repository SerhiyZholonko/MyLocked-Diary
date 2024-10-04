//
//  ICloudSyncView.swift
//  MyLockedDiary
//
//  Created by apple on 04.10.2024.
//

import SwiftUI

struct ICloudSyncView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("iCloud Sync View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    ICloudSyncView()
        .environmentObject(MainTabViewViewModel())

}
