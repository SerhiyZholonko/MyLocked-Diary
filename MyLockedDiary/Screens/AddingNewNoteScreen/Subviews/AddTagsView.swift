//
//  AddTagsView.swift
//  MyLockedDiary
//
//  Created by apple on 04.09.2024.
//
import SwiftUI
struct AddTagsView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Environment(\.dismiss) private var dismiss
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 3)
    @State private var newTag: String = ""

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if viewModel.isAddTag {
                        HStack {
                            TextField("Enter new tag", text: $newTag)
                                .padding()
                                .background(.secondary.opacity(0.3))
                                .cornerRadius(10)
                                .focused($isTextFieldFocused)
                                .onAppear {
                                    isTextFieldFocused = true
                                }

                            Button {
                                guard newTag != "", newTag.count >= 3 else { return }
                                viewModel.addNewTag(newTag)
                                newTag = ""
//                                withAnimation {
                                    viewModel.isAddTag = false
//                                }

                            } label: {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .tint(viewModel.getSelectedColor())
                                    .frame(width: 50)
                                    .padding()
                                    .background(.secondary.opacity(0.3))
                                    .cornerRadius(10)
                                    .tint(viewModel.getSelectedColor())
                            }
                            .contentShape(Rectangle())
                            .disabled(newTag.count < 3)
                        }
                    }
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.tags, id: \.self) { tag in
                            ZStack(alignment: .topTrailing) {
                                Text("#\(tag)")
                                    .frame(width: 100, height: 48)
                                    .background(viewModel.selectedTags.contains(tag) ? Color.green.opacity(0.3) : Color.secondary.opacity(0.3))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        viewModel.addTagToSelected(tag) // Toggle selection
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
                    viewModel.showDeleteButton = [:]
                }
            }
            .toolbar {
                if !viewModel.isAddTag {
                    Button {
                        // You can now handle the selected tags here, for example:
                        print("Selected tags: \(viewModel.selectedTags)")
                        viewModel.isAddTag.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(viewModel.getSelectedColor())
                    }
                }

                Button {
                    if !viewModel.isAddTag {
                        dismiss()
                    }
//                    withAnimation {
                       
                        viewModel.isAddTag = false
//                    }
                    
                } label: {
                    Image(systemName: "checkmark")
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
