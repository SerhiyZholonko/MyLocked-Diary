//
//  AddingNewNoteScreen.swift
//  MyLockedDiary
//
//  Created by apple on 17.08.2024.
//

import SwiftUI
import SwiftData

struct AddingNewNoteScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isEmojiView: Bool = false
    @State private var isSetBackgroundGridView: Bool = false
    @State var noteTitle: String = ""
    @State var noteText: String = ""
    @State var currentEmoji: String = "smile"
    //"face.smiling"
    @State private var currentView: NoteViewCase = .none    
    
    var sheetView: some View {
        switch currentView {
        case .rectanglePortrait:
            return AnyView(
                SetBackgroundGridView()
                .environmentObject(viewModel))
                
        case .photo:
            return AnyView(EmptyView())
        case .listBullet:
            return AnyView(EmptyView())
        case .smile:
            return AnyView(EmptyView())
        case .textFormatSize:
            return AnyView(EmptyView())
        case .tag:
            return AnyView(EmptyView())
        case .none:
            return AnyView(EmptyView()) // or another default view
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    TextField("Enter title", text: $noteTitle)
                        .focused($isTextFieldFocused)
                    Button {
                        isEmojiView.toggle()
                    } label: {
                        Image(currentEmoji)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(10)
                            .background(viewModel.getSelectedColor())
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle()) // This removes the default
                }
                ZStack {
                    TransparentTextEditor(text: $noteText)
                        .background(Color.secondary.opacity(0.3))
                        .cornerRadius(8)
                        .focused($isTextFieldFocused)
                    if isEmojiView {
                        EmojiCollectionView(getImageName: { currentImageName in
                            currentEmoji = currentImageName
                            isEmojiView.toggle()
                        })
                            .frame(height: 150)
                            .cornerRadius(10)

                    }
                }
                .frame(height: 150)

               
                Button("Create") {
                    let newNote = Note(title: noteTitle, noteText: noteText)
                    context.insert(newNote)
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        print("Error saving note: \(error.localizedDescription)")
                        // You might want to show an alert to the user here
                    }
                }
                .foregroundStyle(.black)
                .tint(viewModel.getSelectedColor())
                .disabled(noteTitle.isEmpty || noteText.isEmpty)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            Spacer()
            AddNoteBottomView(dismissKeybourd: {
                hideKeyboard()
            }, currentView: $currentView)
            .onChange(of: currentView) { oldValue, newValue in
                print("currentView changed from \(oldValue) to \(newValue)")
                guard currentView != .none else { return }
                isSetBackgroundGridView.toggle()
            }            .padding(.leading)

        }
        .toolbar {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .tint(viewModel.getSelectedColor())
            }
        }
        .background(viewModel.getThemeBackgroundColor())
        .navigationTitle("Adding new note")
        .fullScreenCover(isPresented: $isSetBackgroundGridView) {
            sheetView
                .onDisappear {
                                   isSetBackgroundGridView = false
                    currentView = .none
                               }
        }
        
    }
}

#Preview {
    NavigationStack {
        AddingNewNoteScreen()
            .environmentObject(MainTabViewViewModel())
    }
}


extension View {
    func hideKeyboard() {
        UIView.animate(withDuration: 0.2) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


