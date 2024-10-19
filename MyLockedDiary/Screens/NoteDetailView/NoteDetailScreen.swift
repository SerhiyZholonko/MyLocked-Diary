//
//  NoteDetailView.swift
//  MyLockedDiary
//
//  Created by apple on 25.09.2024.
//

import SwiftUI
import SwiftData

struct NoteDetailScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @State private var showingEditNoteView = false
    @State private var currentNote: Note
    private var note: Note

    init(note: Note) {
        self.note = note
        self._currentNote = State(initialValue: note) // Properly initialize currentNote
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(currentNote.date.toStringNoteDetail())
                    .font(.system(size: 20))
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.fromHex( currentNote.energyColor) )
                    Image(systemName: currentNote.energyImageName)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .frame(width: 40, height: 40)
                ZStack {
                    Circle()
                        .fill(viewModel.getSelectedColor())
//                    Text(currentNote.emoji)
                    Text(viewModel.currentNote?.emoji ?? viewModel.currentEmoji)
                       
                }
                    .frame(width: 40, height: 40)
            }
            HStack {
                Text(currentNote.title)
                Spacer()
            }
            HStack {
                Text(currentNote.noteText)
                Spacer()
            }
           

            Spacer()
        }
        .font(Font(viewModel.selectedFont))
        .foregroundColor(viewModel.selectedFontColor?.color)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            viewModel.isEditView = true
            viewModel.currentNote = note
            viewModel.noteTitle = note.title
            viewModel.noteText = note.noteText
            viewModel.date = note.date
            viewModel.currentEmoji = note.emoji
            viewModel.selectedEnergyImageName = note.energyImageName
            viewModel.selectedEnergyColor = note.energyColor.toColor()
            viewModel.selectedImages = note.imagesData?.compactMap { data in
                if let originalImage = UIImage(data: data) {
                    // Compress the image (e.g., 0.5 for medium quality)
                    if let compressedData = originalImage.jpegData(compressionQuality: 0.2) {
                        return UIImage(data: compressedData)
                    }
                }
                return nil
            } ?? []
            showingEditNoteView.toggle()
        }
        .background(viewModel.getThemeBackgroundColor())
        .fullScreenCover(isPresented: $showingEditNoteView) {
            NavigationStack {
                AddingNewNoteScreen
                { newNote in
                                   currentNote = newNote // Update currentNote
                    dismiss()
                               }
                .environmentObject(viewModel)
            }
        }
        .toolbar {
            Button {
                context.delete(note)  // Delete the note from the context
                   
                   do {
                       try context.save()  // Save the context to persist the deletion
                       dismiss()  // Dismiss the view after deletion
                   } catch {
                       print("Failed to delete the note: \(error)")
                   }
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 20, weight: .bold))
                    .tint(viewModel.getSelectedColor())
                
            }
            //checkmark
            Button {
                dismiss()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .bold))
                    .tint(viewModel.getSelectedColor())
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let imagesData = currentNote.imagesData {
                viewModel.selectedImages = imagesData.compactMap { UIImage(data: $0) }
            } else {
                viewModel.selectedImages = []
            }
            print("selectedImages NoteDetailScreen", viewModel.selectedImages)
        }

    }
}

#Preview {
    NoteDetailScreen(note:  Note(title: "title", noteText: "Some text", date: Date(), energyColor: .red, energyImageName: "String",
                                 emoji: "String"))
}
