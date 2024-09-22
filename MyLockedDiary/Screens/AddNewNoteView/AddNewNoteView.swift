//
//  AddNewNoteView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI
import SwiftData

struct AddNewNoteView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Query private var notes: [Note]
    @State private var showingNewNoteView = false // State to control sheet presentation
    @State private var showingEditNoteView = false // State to control sheet presentation

    let columns = [GridItem(.flexible())]
    
    @State private var currentDetent: PresentationDetent = .fraction(1.0)
    
    @State private var currentNote: Note?
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(viewModel.getHeaderImageName())
                    .resizable()
                    .frame(height: 200)
                Color.clear
                    .frame(height: 5)
                
                List {
                    ForEach(notes) { note in
                        SingleNodeView(note: note, dividerColor: viewModel.getTintColor(), emojiBgColor: viewModel.getSelectedColor())
                            .background(viewModel.getThemeBackgroundColor())
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                viewModel.isEditView = true
                                currentNote = note
                                viewModel.noteTitle = note.title
                                viewModel.noteText = note.noteText
                                viewModel.date = note.date
                                viewModel.currentEmoji = note.emoji
                                viewModel.selectedEnergyImageName = note.energyImageName
                                viewModel.selectedEnergyColor = note.energyColor.toColor()
                                showingEditNoteView.toggle()
                            }
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteNote(at: IndexSet(integer: notes.firstIndex(of: note)!))
                            } label: {
                                VStack {
                                    Image(systemName: "trash")
                                }
                                
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

                .background(viewModel.getThemeBackgroundColor())
                .padding()
                Spacer()
            }
            .background(viewModel.getThemeBackgroundColor())
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.isEditView = false
                        showingNewNoteView = true // Show the sheet
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .background(.white)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .foregroundColor(viewModel.getSelectedColor())
                            .shadow(color: .gray, radius: 14, x: 0, y: 2) // Add shadow
                            .padding(.horizontal, 40)
                    }
                    .fullScreenCover(isPresented: $showingNewNoteView) {
                        NavigationStack {
                            AddingNewNoteScreen()
                                .environmentObject(viewModel)
                        }
                    }
                    .fullScreenCover(isPresented: $showingEditNoteView) {
                        NavigationStack {
//                            if let currentNote = currentNote {
                            
                                AddingNewNoteScreen()
                                    .environmentObject(viewModel)
//                            }
                            }
                          
                    }
                }
            }
            .offset(y: -100)
        }
        .background(viewModel.getThemeBackgroundColor())
        .onAppear{
            print("notes", notes.count)
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = notes[index]
            context.delete(noteToDelete)  // Delete the note from the context
        }
        
        // Save the context after deleting the notes
        do {
            try context.save()
        } catch {
            print("Error deleting note: \(error.localizedDescription)")
            // You could show an alert here to inform the user if needed
        }
    }
}



#Preview {
    AddNewNoteView()
        .environmentObject(MainTabViewViewModel())
        .modelContainer(for: Note.self, inMemory: true)
    
}
