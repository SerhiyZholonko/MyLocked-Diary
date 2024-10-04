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
    @Query private var notes: [Note]

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
                    Text(currentNote.emoji)
                       
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
            showingEditNoteView.toggle()
        }
        .background(viewModel.getThemeBackgroundColor())
        .fullScreenCover(isPresented: $showingEditNoteView) {
            NavigationStack {
                AddingNewNoteScreen
                { newNote in
                                   currentNote = newNote // Update currentNote
                               }
                .environmentObject(viewModel)
            }
        }
        .toolbar {
            Button {
                print("delete note here")
                context.delete(note)  // Delete the note from the context
                dismiss()
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

    }
}

#Preview {
    NoteDetailScreen(note:  Note(title: "title", noteText: "Some text", date: Date(), energyColor: .red, energyImageName: "String",
                                 emoji: "String"))
}
