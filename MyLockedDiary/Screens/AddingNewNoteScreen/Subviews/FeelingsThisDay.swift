//
//  FeelingsThisDay.swift
//  MyLockedDiary
//
//  Created by apple on 05.09.2024.
//

import SwiftUI

struct FeelingsThisDay: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Environment(\.dismiss) private var dismiss
    var getImageName: (String) -> Void
//    let images = ["confused", "cool", "emoji", "sad", "shocked", "smile-2", "smile2", "wow"] // Replace with your image names
    
    let columns = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.feelings) { item in
                        VStack {
                            Text(item.emoji)
                                .font(.system(size: 70))
//                                .frame(width: 60, height: 60)
                                .cornerRadius(8) // Optional: for rounded corners
                                .onTapGesture {
                                    viewModel.selectedFeeling = item
                                }
                            Text(item.name)
                                .font(.system(size: 16))
                        }
                       
                    }
                }
                .padding()
            }
            .toolbar(content: {
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .tint(viewModel.getSelectedColor())

                }

            })
            .background(viewModel.getThemeBackgroundColor())
            .navigationTitle("How do you feeling this day?")
            .navigationBarTitleDisplayMode(.inline)
        }
            }
}

#Preview {
    FeelingsThisDay(getImageName: {_ in })
}
