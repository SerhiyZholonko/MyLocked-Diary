//
//  AddTagsView.swift
//  MyLockedDiary
//
//  Created by apple on 04.09.2024.
//

import SwiftUI

struct AddTagsView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Environment (\.dismiss) private var dismiss
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 3) // Four columns with flexible width
    @State private var newTag: String = ""

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if viewModel.isAddTag {
                        TextField("Enter new tag", text: $newTag)
                            .padding()
                            .background(.secondary.opacity(0.3))
                            .cornerRadius(10)
                            .focused($isTextFieldFocused)  // Attach the focus state to the TextField
                                       .onAppear {
                                           isTextFieldFocused = true  // Set focus when the view appears
                                       }
                    }
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.tags, id: \.self) { tag in
                            ZStack(alignment: .topTrailing) {
                                Text("#\(tag)")
                                    .frame(width: 100, height: 48)
                                    .background(Color.secondary.opacity(0.3))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        if viewModel.showDeleteButton[tag] == false {
                                            print(tag)  // This will print the tag when tapped
                                            viewModel.addTagToSelected(tag)
                                        } else {
                                            // Hide delete button on tap if it's showing
                                            withAnimation {
                                                viewModel.showDeleteButton[tag] = false
                                            }
                                        }
                                    }
                                    .onLongPressGesture {
                                        withAnimation {
                                            viewModel.showDeleteButton[tag] = true
                                        }
                                    }

                                if viewModel.showDeleteButton[tag] == true {
                                    Button(action: {
                                        if let index = viewModel.tags.firstIndex(of: tag) {
                                            viewModel.tags.remove(at: index)
                                            viewModel.showDeleteButton[tag] = false
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 10, y: -10)
                                }
                            }
                            .padding(4)
                        }
                    }



                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            
            .background(viewModel.getThemeBackgroundColor())
            .onTapGesture {
                withAnimation {
                    viewModel.showDeleteButton = [:] // Dismiss all delete buttons
                }
            }
            .toolbar {
                Button {
                    viewModel.isAddTag.toggle()
                        guard newTag != "", newTag.count >= 3 else { return }
                        viewModel.addNewTag(newTag)
                newTag = ""
                } label: {
                    Text(viewModel.isAddTag ? "Save" : "Add")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(viewModel.getSelectedColor())
                }
                .disabled(viewModel.isAddTag && newTag.count<3)

                Button {
                    dismiss()
                    viewModel.isAddTag.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .tint(viewModel.getSelectedColor())
                    
                    
                    
                }
            }
        }
    }
}

#Preview {
    AddTagsView()
}
