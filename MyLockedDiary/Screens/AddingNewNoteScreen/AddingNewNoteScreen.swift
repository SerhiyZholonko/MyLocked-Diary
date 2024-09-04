//
//  AddingNewNoteScreen.swift
//  MyLockedDiary
//
//  Created by apple on 17.08.2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddingNewNoteScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isEmojiView: Bool = false
    @State private var isSetBackgroundGridView: Bool = false
    @State private var showImagePicker = false
    @State private var isNumberingEnabled: Bool = true // Control numbering here
    @State private var isPhotoPickerPresented = false // New state variable for the photo picker
    @State private var isSelectFont: Bool = false
   
    @State private var isListInTextView: Bool = false//  for adding list in text view
    @State private var isKindOfListView: Bool = false// for showing KaidOfListView
    
    @State private var isTagView: Bool = false// for show tagView
    
    @State private var shouldFocus: Bool = false
    
    @State private var selectedImage: UIImage?
    @State var noteTitle: String = ""
    @State var noteText: String = ""
    @State var currentEmoji: String = "smile"
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
   
    @State private var currentView: NoteViewCase = .none
    
    
    private var selectedFont: UIFont = UIFont.systemFont(ofSize: 17) // Default font

    
    var body: some View {
        ZStack {
            
            ScrollView {
                Group {
                    HStack {
                        TextField("Enter title", text: $noteTitle)
                            .font(viewModel.selectedFont 
                                  != nil ? Font(viewModel.selectedFont! as CTFont) : .system(size: 16)) // Apply font from viewModel if available
                            .foregroundColor(viewModel.selectedFontColor!.color)
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
                        TransparentTextEditor(text: $noteText, isNumberingEnabled: $isListInTextView, shouldFocus: $shouldFocus, font: viewModel.selectedFont ?? UIFont.systemFont(ofSize: 16), fontColor: viewModel.selectedFontColor!.color )
                
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
                    if !viewModel.selectedTags.isEmpty {
                        HStack {
                            ForEach(viewModel.selectedTags, id: \.self) { tag in
                                HStack {
                                    Text("#")
                                        .font(.system(size: 24))  // Sets the font size to 24

                                    Text(tag)
                                        .font(.system(size: 15))  // Sets the font size to 15
                                }
                            }
                            Spacer()
                        }
                    }
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
                if !selectedImages.isEmpty {
                    VStack {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
                
                
            }
            .onTapGesture {
                  hideKeyboard()
              }
              
            VStack(alignment: .leading) {
                Spacer()
                AddNoteBottomView(dismissKeybourd: {
                    hideKeyboard()
                }, currentView: $currentView)
                .environmentObject(viewModel)
                .onChange(of: currentView) { oldValue, newValue in
                    switch newValue {
                    case .rectanglePortrait:
                        isSetBackgroundGridView.toggle() // Present grid view
                    case .photo:
                        isPhotoPickerPresented.toggle() // Toggle photo picker presentation
                    case .listBullet:
//                        isListInTextView.toggle()
                        isKindOfListView.toggle()
                    case .textFormatSize:
                        isSelectFont.toggle()
                    case .tag:
                        isTagView.toggle()
                        
                    default:
                        break
                    }
                }
                .padding(.leading)
            }
            .zIndex(1)
            .padding(.bottom)
           
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
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isSetBackgroundGridView) {
            SetBackgroundGridView()
                .environmentObject(viewModel)
                .onDisappear {
                    isSetBackgroundGridView = false
                    currentView = .none
                }
        }
        
        //MARK: - select font
        .sheet(isPresented: $isSelectFont, content: {
            SelectFontView()
                .environmentObject(viewModel)
                .presentationDetents([.medium]) // Set the presentation style to medium
        })
        .sheet(isPresented: $isKindOfListView, content: {
            KindOfListView()
                .environmentObject(viewModel)
                .presentationDetents([.medium]) // Set the presentation style to medium
        })
        .sheet(isPresented: $isTagView, content: {
            AddTagsView()
                .environmentObject(viewModel)
                .presentationDetents([viewModel.isAddTag ? .fraction(1.0) : .medium]) // Set the presentation style to medium
        })
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $selectedItems, maxSelectionCount: 5, matching: .images)
      
        .onChange(of: isPhotoPickerPresented, { oldValue, newValue in
            if !newValue {
                currentView = .none

            }
        })
        .onChange(of: isListInTextView, { oldValue, newValue in
            
            if !newValue {
                currentView = .none
                noteText.append("\n")
                shouldFocus = true

            } else {
                currentView = .none
                noteText.append("\n   1. ")
                shouldFocus = true
            }
        })
        .onChange(of: isKindOfListView, { oldValue, newValue in
            if !newValue {
                currentView = .none

            }
        })
        .onChange(of: isSelectFont, { oldValue, newValue in
            if !newValue {
                currentView = .none

            }
        })
       
        .onChange(of: selectedItems) {  oldValue, newValue in
            selectedImages.removeAll() // Clear previous images
            Task {
                for item in newValue {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImages.append(uiImage)
                    }
                }
            }


        }
        .onChange(of: isTagView) { oldValue, newValue in
            if !newValue {
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






