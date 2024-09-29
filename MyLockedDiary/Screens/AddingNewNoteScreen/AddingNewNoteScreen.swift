//
//  AddingNewNoteScreen.swift
//  MyLockedDiary
//
//  Created by apple on 17.08.2024.
//
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
    
    @State private var isListInTextView: SelectedList = .none//  for adding list in text view
    @State private var isKindOfListView: Bool = false// for showing KaidOfListView
    
    @State private var isTagView: Bool = false// for show tagView
    
    @State private var shouldFocus: Bool = false
    
    @State private var isEnergyToDay: Bool = false
    
    @State private var isFeelingsThisDay: Bool = false
    
    @State private var selectedImage: UIImage?
   
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isDeleteButtomForImage: Bool = false
    
    @State private var currentView: NoteViewCase = .none
    
    @Query private var notes: [Note]

    private var selectedFont: UIFont = UIFont.systemFont(ofSize: 17) // Default font
    
    
    var onNoteAdded: ((Note) -> Void)?

       init(onNoteAdded: ((Note) -> Void)? = nil) {
           self.onNoteAdded = onNoteAdded
       }
    var body: some View {
        ZStack {
            
            ScrollView {
                Group {
                    HStack {
                        TextField("Enter title", text: $viewModel.noteTitle)
                            .font(viewModel.selectedFont
                                  != nil ? Font(viewModel.selectedFont! as CTFont) : .system(size: 16)) // Apply font from viewModel if available
                            .foregroundColor(viewModel.selectedFontColor!.color)
                            .focused($isTextFieldFocused)
                        Button {
                            isEnergyToDay.toggle()
                        } label: {
                            Image("bolt")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(10)
                                .background(viewModel.selectedEnergyColor)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle()) // This removes the default
                        Button {
                            isFeelingsThisDay.toggle()
                        } label: {
                            if let item = viewModel.selectedFeeling {
                                Text(item.emoji)
                                    .font(.system(size: 32))
                                    .frame(width: 32, height: 32)
                                    .padding(10)
                                    .background(viewModel.getSelectedColor())
                                    .cornerRadius(10)
                            } else if !viewModel.currentEmoji.isEmpty {
                                Text(viewModel.currentEmoji)
                                    .font(.system(size: 32))
                                    .frame(width: 32, height: 32)
                                    .padding(10)
                                    .background(viewModel.getSelectedColor())
                                    .cornerRadius(10)
                            } else {
                                Image("smile")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .padding(10)
                                    .background(viewModel.getSelectedColor())
                                    .cornerRadius(10)
                            }
                            
                        }
                        .buttonStyle(PlainButtonStyle()) // This removes the default
                    }
                    ZStack {
                        TransparentTextEditor(text: $viewModel.noteText, isNumberingEnabled: $isListInTextView, shouldFocus: $shouldFocus, font: viewModel.selectedFont ?? UIFont.systemFont(ofSize: 16), fontColor: viewModel.selectedFontColor!.color )
                        
                            .background(Color.secondary.opacity(0.3))
                            .cornerRadius(8)
                            .focused($isTextFieldFocused)
                        
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
                    if !selectedImages.isEmpty {
                        VStack {
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) { // Spacing between images
                                    ForEach(selectedImages, id: \.self) { image in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill() // Use scaledToFill for better fit within fixed size
                                                .frame(width: 100, height: 100) // Fixed size for image
                                                .cornerRadius(8)
                                                .clipped() // Ensure image does not overflow the fixed size
                                            
                                            
                                            if isDeleteButtomForImage {
                                                Button(action: {
                                                    if let index = selectedImages.firstIndex(of: image) {
                                                        selectedImages.remove(at: index) // Remove the image on button tap
                                                    }
                                                    viewModel.updateNode()
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                        .background(Color.white.clipShape(Circle()))
                                                        .frame(width: 24, height: 24) // Fixed size for the button
                                                        .padding(4)
                                                        .tint(Color.clear)
                                                }
                                                .offset(x: 15, y: -15) // Adjust button position
                                            }
                                        }
                                        
                                    }
                                }
                                .padding() // Add padding to the HStack for better appearance
                            }
                            .frame(height: 120) // Fixed height for the scroll view to fit images
                            .zIndex(2)
                        }
                        
                    }
                    Button {
                        let newNote = Note(
                            
                            title: viewModel.noteTitle,
                            noteText:  viewModel.noteText,
                            date: viewModel.date,
                            energyColor: viewModel.selectedEnergyColor,
                            energyImageName: viewModel.selectedEnergyImageName,
                            emoji: viewModel.currentNote?.emoji ?? ""
                        )
                        
                        // Find and delete the old note from the context if it exists
                        if let oldNote = notes.first(where: { $0.date.toString() == newNote.date.toString() }) {
                            context.delete(oldNote)
                        }
                        onNoteAdded?(newNote)
                        // Insert the new note
                        context.insert(newNote)

                        do {
                            try context.save()
                            viewModel.updateNode()
                            dismiss()
                        } catch {
                            print("Error saving note: \(error.localizedDescription)")
                        }
                    }

                    label: {
                        Text( viewModel.isEditView ? "Update" : "Create")
                    }
                    
                    .foregroundStyle(.black)
                    .tint(viewModel.getSelectedColor())
                    .disabled(viewModel.noteTitle.isEmpty || viewModel.noteText.isEmpty)
                    .buttonStyle(.borderedProminent)

                    
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
                
                
                
                Spacer()
                
                
            }
            .onTapGesture {
                hideKeyboard()
                isDeleteButtomForImage = false

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
                        isKindOfListView.toggle()
                        isListInTextView = .none
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
            if !selectedImages.isEmpty {
                Button {
                    isDeleteButtomForImage.toggle() // Toggle delete button on long press
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .bold))
                        .tint(viewModel.getSelectedColor())
                    
                }
            }
            Button {
                dismiss()
                viewModel.updateNode()
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
        
        //MARK: - sheets
        .sheet(isPresented: $isSelectFont, content: {
            SelectFontView()
                .environmentObject(viewModel)
                .presentationDetents([.medium]) // Set the presentation style to medium
        })
        .sheet(isPresented: $isKindOfListView, content: {
            KindOfListView(selectedList: $isListInTextView)
                .environmentObject(viewModel)
                .presentationDetents([.medium]) // Set the presentation style to medium
        })
        .sheet(isPresented: $isTagView, content: {
            AddTagsView()
                .environmentObject(viewModel)
                .presentationDetents([viewModel.isAddTag ? .fraction(1.0) : .medium]) // Set the presentation style to medium
        })
        .sheet(isPresented: $isEnergyToDay, content: {
            EnergyThisDay()
                .environmentObject(viewModel)
                .presentationDetents([ .medium]) // Set the presentation style to medium
        })
        .sheet(isPresented: $isFeelingsThisDay, content: {
            FeelingsThisDay(getImageName: { currentImageName in
                viewModel.currentEmoji = currentImageName
              //  viewModel.selectedEmoji
                isEmojiView.toggle()
            })
            .environmentObject(viewModel)
            .presentationDetents([ .medium]) // Set the presentation style to medium
        })
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $selectedItems, maxSelectionCount: 5, matching: .images)
        
        .onChange(of: isPhotoPickerPresented, { oldValue, newValue in
            if !newValue {
                currentView = .none
            }
        })
        .onChange(of: isListInTextView, { oldValue, newValue in
            
            if newValue == .none {
                viewModel.selectedList = newValue
                currentView = .none
                viewModel.noteText.append("\n")
                shouldFocus = true
            } else {
                viewModel.selectedList = newValue

                currentView = .none
                switch newValue {
                    
                case .numbered:
                    viewModel.noteText.append("\n   1. ")

                case .simpleNumbered:
                    viewModel.noteText.append("\n   1) ")

                case .star:
                    viewModel.noteText.append("\n   ★ ")
                case .point:
                    viewModel.noteText.append("\n   ● ")

                case .heart:
                    viewModel.noteText.append("\n   ❤️ ")

                case .greenPoint:
                    viewModel.noteText.append("\n   🟢 ")

                case .none:
                    viewModel.noteText.append("\n")
                }
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




//import SwiftUI
//import SwiftData
//import PhotosUI
//
//struct AddingNewNoteScreen: View {
//    @Environment(\.modelContext) private var context
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject var viewModel: MainTabViewViewModel
//    @FocusState private var isTextFieldFocused: Bool
//    @State private var isEmojiView: Bool = false
//    @State private var isSetBackgroundGridView: Bool = false
//    @State private var showImagePicker = false
//    @State private var isNumberingEnabled: Bool = true // Control numbering here
//    @State private var isPhotoPickerPresented = false // New state variable for the photo picker
//    @State private var isSelectFont: Bool = false
//    
//    @State private var isListInTextView: SelectedList = .none//  for adding list in text view
//    @State private var isKindOfListView: Bool = false// for showing KaidOfListView
//    
//    @State private var isTagView: Bool = false// for show tagView
//    
//    @State private var shouldFocus: Bool = false
//    
//    @State private var isEnergyToDay: Bool = false
//    
//    @State private var isFeelingsThisDay: Bool = false
//    
//    @State private var selectedImage: UIImage?
////    @State var noteTitle: String = ""
////    @State var noteText: String = ""
////    @State var date =  Date.now
//    //Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!
////    @State var currentEmoji: String = "smile"
//   
//    @State private var selectedItems: [PhotosPickerItem] = []
//    @State private var selectedImages: [UIImage] = []
//    @State private var isDeleteButtomForImage: Bool = false
//    
//    @State private var currentView: NoteViewCase = .none
//    
//    
//    private var selectedFont: UIFont = UIFont.systemFont(ofSize: 17) // Default font
//    
//    
//
////        var onNoteAdded: ((Note) -> Void)?
//    
////           init(onNoteAdded: ((Note) -> Void)? = nil) {
////               self.onNoteAdded = onNoteAdded
////           }
//    var body: some View {
//        ZStack {
//            
//            ScrollView {
//                Group {
//                    HStack {
//                        TextField("Enter title", text: $viewModel.noteTitle)
//                            .font(viewModel.selectedFont
//                                  != nil ? Font(viewModel.selectedFont! as CTFont) : .system(size: 16)) // Apply font from viewModel if available
//                            .foregroundColor(viewModel.selectedFontColor!.color)
//                            .focused($isTextFieldFocused)
//                        Button {
//                            isEnergyToDay.toggle()
//                        } label: {
//                            Image("bolt")
//                                .resizable()
//                                .frame(width: 32, height: 32)
//                                .padding(10)
//                                .background(viewModel.selectedEnergyColor)
//                                .cornerRadius(10)
//                        }
//                        .buttonStyle(PlainButtonStyle()) // This removes the default
//                        Button {
//                            isFeelingsThisDay.toggle()
//                        } label: {
//                            if let item = viewModel.selectedFeeling {
//                                Text(item.emoji)
//                                    .font(.system(size: 32))
//                                    .frame(width: 32, height: 32)
//                                    .padding(10)
//                                    .background(viewModel.getSelectedColor())
//                                    .cornerRadius(10)
//                            } else if !viewModel.currentEmoji.isEmpty {
//                                Text(viewModel.currentEmoji)
//                                    .font(.system(size: 32))
//                                    .frame(width: 32, height: 32)
//                                    .padding(10)
//                                    .background(viewModel.getSelectedColor())
//                                    .cornerRadius(10)
//                            } else {
//                                Image("smile")
//                                    .resizable()
//                                    .frame(width: 32, height: 32)
//                                    .padding(10)
//                                    .background(viewModel.getSelectedColor())
//                                    .cornerRadius(10)
//                            }
//                            
//                        }
//                        .buttonStyle(PlainButtonStyle()) // This removes the default
//                    }
//                    ZStack {
//                        TransparentTextEditor(text: $viewModel.noteText, isNumberingEnabled: $isListInTextView, shouldFocus: $shouldFocus, font: viewModel.selectedFont ?? UIFont.systemFont(ofSize: 16), fontColor: viewModel.selectedFontColor!.color )
//                        
//                            .background(Color.secondary.opacity(0.3))
//                            .cornerRadius(8)
//                            .focused($isTextFieldFocused)
//                        
//                    }
//                    .frame(height: 150)
//                    if !viewModel.selectedTags.isEmpty {
//                        HStack {
//                            ForEach(viewModel.selectedTags, id: \.self) { tag in
//                                HStack {
//                                    Text("#")
//                                        .font(.system(size: 24))  // Sets the font size to 24
//                                    
//                                    Text(tag)
//                                        .font(.system(size: 15))  // Sets the font size to 15
//                                }
//                            }
//                            Spacer()
//                        }
//                    }
//                    if !selectedImages.isEmpty {
//                        VStack {
//                            
//                            ScrollView(.horizontal) {
//                                HStack(spacing: 10) { // Spacing between images
//                                    ForEach(selectedImages, id: \.self) { image in
//                                        ZStack(alignment: .topTrailing) {
//                                            Image(uiImage: image)
//                                                .resizable()
//                                                .scaledToFill() // Use scaledToFill for better fit within fixed size
//                                                .frame(width: 100, height: 100) // Fixed size for image
//                                                .cornerRadius(8)
//                                                .clipped() // Ensure image does not overflow the fixed size
//                                            
//                                            
//                                            if isDeleteButtomForImage {
//                                                Button(action: {
//                                                    if let index = selectedImages.firstIndex(of: image) {
//                                                        selectedImages.remove(at: index) // Remove the image on button tap
//                                                    }
//                                                    viewModel.updateNode()
//                                                }) {
//                                                    Image(systemName: "xmark.circle.fill")
//                                                        .foregroundColor(.red)
//                                                        .background(Color.white.clipShape(Circle()))
//                                                        .frame(width: 24, height: 24) // Fixed size for the button
//                                                        .padding(4)
//                                                        .tint(Color.clear)
//                                                }
//                                                .offset(x: 15, y: -15) // Adjust button position
//                                            }
//                                        }
//                                        
//                                    }
//                                }
//                                .padding() // Add padding to the HStack for better appearance
//                            }
//                            .frame(height: 120) // Fixed height for the scroll view to fit images
//                            .zIndex(2)
//                        }
//                        
//                    }
//                    Button {
//                        let newNote = Note(
//                            title: viewModel.noteTitle,
//                            noteText:  viewModel.noteText,
//                            date: viewModel.date,
//                            energyColor: viewModel.selectedEnergyColor,
//                            energyImageName: viewModel.selectedEnergyImageName,
//                            emoji: viewModel.selectedFeeling?.emoji ?? ""
//                        )
//                        context.insert(newNote)
//                        
//                        do {
//                            try context.save()
//                            viewModel.updateNode()
//                            dismiss()
//                        } catch {
//                            print("Error saving note: \(error.localizedDescription)")
//                            // You might want to show an alert to the user here
////                            dismiss()
//
//                        }
//                    } label: {
//                        Text( viewModel.isEditView ? "Update" : "Create")
//                    }
//                    
//                    .foregroundStyle(.black)
//                    .tint(viewModel.getSelectedColor())
//                    .disabled(viewModel.noteTitle.isEmpty || viewModel.noteText.isEmpty)
//                    .buttonStyle(.borderedProminent)
//
//                    
//                    
//                    
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.horizontal)
//                
//                
//                
//                Spacer()
//                
//                
//            }
//            .onTapGesture {
//                hideKeyboard()
//                isDeleteButtomForImage = false
//
//            }
//            
//            VStack(alignment: .leading) {
//                Spacer()
//                AddNoteBottomView(dismissKeybourd: {
//                    hideKeyboard()
//                }, currentView: $currentView)
//                .environmentObject(viewModel)
//                .onChange(of: currentView) { oldValue, newValue in
//                    switch newValue {
//                    case .rectanglePortrait:
//                        isSetBackgroundGridView.toggle() // Present grid view
//                    case .photo:
//                        isPhotoPickerPresented.toggle() // Toggle photo picker presentation
//                    case .listBullet:
//                        isKindOfListView.toggle()
//                        isListInTextView = .none
//                    case .textFormatSize:
//                        isSelectFont.toggle()
//                    case .tag:
//                        isTagView.toggle()
//                        
//                    default:
//                        break
//                    }
//                }
//                .padding(.leading)
//            }
//            .zIndex(1)
//            .padding(.bottom)
//            
//        }
//        
//        .toolbar {
//            if !selectedImages.isEmpty {
//                Button {
//                    isDeleteButtomForImage.toggle() // Toggle delete button on long press
//                } label: {
//                    Image(systemName: "trash")
//                        .font(.system(size: 20, weight: .bold))
//                        .tint(viewModel.getSelectedColor())
//                    
//                }
//            }
//            Button {
//                dismiss()
//                viewModel.updateNode()
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.system(size: 20, weight: .bold))
//                    .tint(viewModel.getSelectedColor())
//            }
//        }
//        .background(viewModel.getThemeBackgroundColor())
//        .navigationTitle("Adding new note")
//        .navigationBarTitleDisplayMode(.inline)
//        .fullScreenCover(isPresented: $isSetBackgroundGridView) {
//            SetBackgroundGridView()
//                .environmentObject(viewModel)
//                .onDisappear {
//                    isSetBackgroundGridView = false
//                    currentView = .none
//                }
//        }
//        
//        //MARK: - sheets
//        .sheet(isPresented: $isSelectFont, content: {
//            SelectFontView()
//                .environmentObject(viewModel)
//                .presentationDetents([.medium]) // Set the presentation style to medium
//        })
//        .sheet(isPresented: $isKindOfListView, content: {
//            KindOfListView(selectedList: $isListInTextView)
//                .environmentObject(viewModel)
//                .presentationDetents([.medium]) // Set the presentation style to medium
//        })
//        .sheet(isPresented: $isTagView, content: {
//            AddTagsView()
//                .environmentObject(viewModel)
//                .presentationDetents([viewModel.isAddTag ? .fraction(1.0) : .medium]) // Set the presentation style to medium
//        })
//        .sheet(isPresented: $isEnergyToDay, content: {
//            EnergyThisDay()
//                .environmentObject(viewModel)
//                .presentationDetents([ .medium]) // Set the presentation style to medium
//        })
//        .sheet(isPresented: $isFeelingsThisDay, content: {
//            FeelingsThisDay(getImageName: { currentImageName in
//                viewModel.currentEmoji = currentImageName
//              //  viewModel.selectedEmoji
//                isEmojiView.toggle()
//            })
//            .environmentObject(viewModel)
//            .presentationDetents([ .medium]) // Set the presentation style to medium
//        })
//        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $selectedItems, maxSelectionCount: 5, matching: .images)
//        
//        .onChange(of: isPhotoPickerPresented, { oldValue, newValue in
//            if !newValue {
//                currentView = .none
//            }
//        })
//        .onChange(of: isListInTextView, { oldValue, newValue in
//            
//            if newValue == .none {
//                viewModel.selectedList = newValue
//                currentView = .none
//                viewModel.noteText.append("\n")
//                shouldFocus = true
//                
//            } else {
//                viewModel.selectedList = newValue
//
//                currentView = .none
//                switch newValue {
//                    
//                case .numbered:
//                    viewModel.noteText.append("\n   1. ")
//
//                case .simpleNumbered:
//                    viewModel.noteText.append("\n   1) ")
//
//                case .star:
//                    viewModel.noteText.append("\n   ★ ")
//                case .point:
//                    viewModel.noteText.append("\n   ● ")
//
//                case .heart:
//                    viewModel.noteText.append("\n   ❤️ ")
//
//                case .greenPoint:
//                    viewModel.noteText.append("\n   🟢 ")
//
//                case .none:
//                    viewModel.noteText.append("\n")
//
//                }
//                shouldFocus = true
//            }
//        })
//        .onChange(of: isKindOfListView, { oldValue, newValue in
//            if !newValue {
//                currentView = .none
//                
//            }
//        })
//        .onChange(of: isSelectFont, { oldValue, newValue in
//            if !newValue {
//                currentView = .none
//                
//            }
//        })
//        
//        .onChange(of: selectedItems) {  oldValue, newValue in
//            selectedImages.removeAll() // Clear previous images
//            Task {
//                for item in newValue {
//                    if let data = try? await item.loadTransferable(type: Data.self),
//                       let uiImage = UIImage(data: data) {
//                        selectedImages.append(uiImage)
//                    }
//                }
//            }
//        }
//        .onChange(of: isTagView) { oldValue, newValue in
//            if !newValue {
//                currentView = .none
//                
//            }
//        }
//    }
////    func setEditNote(_ note: Note) {
//////        @State var noteTitle: String = ""
//////        @State var noteText: String = ""
//////        @State var date =  Date.now
//////        //Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!
//////        @State var currentEmoji: String = "smile"
////        viewModel.noteTitle = note.title
////        viewModel.noteText = note.noteText
////        date = note.date
//////        viewModel.selectedEnergyColor = note.energyColor
//////        viewModel.selectedEnergyImageName = note.energyImageName
////        currentEmoji = note.emoji
////
////
////
////    }
//}
//
//#Preview {
//    NavigationStack {
//        AddingNewNoteScreen()
////        editNote: Note( title: "String",
////                                            noteText: "String",
////                                            date: Date(),
////                                            energyColor: .red,
////                                            energyImageName: "String",
////                                            emoji: "String")
//            .environmentObject(MainTabViewViewModel())
//    }
//}
