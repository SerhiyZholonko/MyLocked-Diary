//
//  AddNewNoteView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct AddNewNoteView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    var body: some View {
        Text("Add new note")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(viewModel.getThemeBackgroundColor())
    }
}

#Preview {
    AddNewNoteView()
        .environmentObject(MainTabViewViewModel())
    
}
