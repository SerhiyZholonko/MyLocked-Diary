//
//  KindOfListView.swift
//  MyLockedDiary
//
//  Created by apple on 04.09.2024.
//

import SwiftUI

enum SelectedList: CaseIterable, Identifiable {
   
    case numbered
    case simpleNumbered
    case star
    case point
    case heart
    case greenPoint
    case none
    var id: Self { self }
    var imageName: String {
        switch self {
        case .numbered:
            return "numberedList"
        case .simpleNumbered:
            return "simpleNumberedList"
        case .star:
            return "starList"
        case .point:
            return "BlackPointList"
        case .heart:
            return "heartRedList"
        case .greenPoint:
            return "greenCircleList"
        case .none:
            return "none"
        }
    }
}

struct KindOfListView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Environment(\.dismiss) private var dismiss
    
   @Binding var selectedList: SelectedList // Track the selected image
    var isSelectedList: Bool {
        return !(selectedList == .none)
    }
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 3) // Grid layout
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(SelectedList.allCases, id: \.self) { imageName in
                            Image(imageName.imageName)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .border(selectedList == imageName && selectedList != .none ? viewModel.getSelectedColor() : Color.clear, width: 4) // Apply border
                                .onTapGesture {
                                    selectedList = imageName // Set selected image in viewModel
                                }
                        }
                    }

//                    LazyVGrid(columns: columns, spacing: 16) {
//                        ForEach(SelectedList.allCases, id: \.self) { imageName in
//                            Image(imageName.imageName)
//                                .resizable()
//                                .frame(width: 100, height: 100)
//                                .cornerRadius(10)
//                            if viewModel.selectedList != .none {
//                                .border(viewModel.selectedList == imageName ? viewModel.getSelectedColor() : Color.clear, width: 4) // Blue border if selected
//                            }
//                                .onTapGesture {
//                                    viewModel.selectedList = imageName // Set selected image
//                                }
//                        }
//                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(viewModel.getThemeBackgroundColor())
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .tint(viewModel.getSelectedColor())
                }
            }
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    KindOfListView(selectedList: .constant(.none))
}
