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
    
    
    @State private var selectedMonth: String = Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
    @State private var selectedYear: String = "\(Calendar.current.component(.year, from: Date()))"
    @State private var searchText: String = ""

       
       let months = Calendar.current.monthSymbols
       let years = Array(2023...Calendar.current.component(.year, from: Date())).map { "\($0)" }

    var filteredNotes: [Note] {
           notes.filter { note in
               let noteMonth = DateFormatter().monthSymbols[Calendar.current.component(.month, from: note.date) - 1]
               let noteYear = "\(Calendar.current.component(.year, from: note.date))"
               let matchesSearch = searchText.isEmpty || note.title.localizedCaseInsensitiveContains(searchText)
               return noteMonth == selectedMonth && noteYear == selectedYear && matchesSearch
           }
       }

    
    var body: some View {
        NavigationStack {
        ZStack {
            VStack(spacing: 0) {
                Image(viewModel.getHeaderImageName())
                    .resizable()
                    .frame(height: 100)
                Color.clear
                    .frame(height: 5)
                // Month Picker
                HStack {
                    Picker("Select Month", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(month).tag(month)
                        }
                    }
                    .padding()

                    // Year Picker
                    Picker("Select Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(year).tag(year)
                        }
                    }
                }
//                // Search Field for title
//                          TextField("Search notes by title", text: $searchText)
//                              .textFieldStyle(RoundedBorderTextFieldStyle())
//                              .padding()
                HStack {
                    Image(systemName: "magnifyingglass") // Add a search icon
                        .foregroundColor(.gray)
                    
                    TextField("Search notes by title", text: $searchText)
                        .padding(10) // Add padding inside the text field
                        .background(Color(.systemGray6)) // Background color
                        .cornerRadius(8) // Rounded corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1) // Border style
                        )
                        .padding(.horizontal) // Outer padding
                }
                .padding(.vertical, 10) // Optional: Adjust vertical padding if needed
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2) // Add shadow for better elevation
                            .padding()
                ScrollView {
                    ForEach(filteredNotes, id: \.id) { note in

                        NavigationLink(destination: NoteDetailScreen(note: note)


                        ) {
                            SingleNodeView(note: note, dividerColor: viewModel.getTintColor(), emojiBgColor: viewModel.getSelectedColor())
                                .environmentObject(viewModel)
                                .background(viewModel.getThemeBackgroundColor())
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .onAppear {
                                    viewModel.currentNote = note
                                }
                        }
                        
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
                .tint(.black)
                .scrollContentBackground(.hidden)
                
                .background(viewModel.getThemeBackgroundColor())
                .padding()
                Spacer()
            }
            .background(viewModel.getThemeBackgroundColor())
            if !viewModel.checkIsNoteToDay(notes: notes) {
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
                                
                                AddingNewNoteScreen()
                                    .environmentObject(viewModel)
                                
                            }
                            
                        }
                    }
                }
                .offset(y: -100)
            }
           
        }
        .background(viewModel.getThemeBackgroundColor())
        
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
