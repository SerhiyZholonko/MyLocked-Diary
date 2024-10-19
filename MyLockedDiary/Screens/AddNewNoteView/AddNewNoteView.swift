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
    @State private var cachedNotes: [Note] = []

    //Problem with delay
    @State private var showingNewNoteView = false // State to control sheet presentation
    @State private var showingEditNoteView = false // State to control sheet presentation

    let columns = [GridItem(.flexible())]
    
    @State private var currentDetent: PresentationDetent = .fraction(1.0)
    
    
    @State private var selectedMonth: String = Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
    @State private var selectedYear: String = "\(Calendar.current.component(.year, from: Date()))"
    @State private var searchText: String = ""

       
       let months = Calendar.current.monthSymbols
       let years = Array(2023...Calendar.current.component(.year, from: Date())).map { "\($0)" }


    @State private var filteredNotes: [Note] = []

    
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
                    ForEach(notes, id: \.id) { note in

                        NavigationLink(destination: NoteDetailScreen(note: note)) {
                            SingleNodeView(note: note, dividerColor: viewModel.getTintColor(), emojiBgColor: viewModel.getSelectedColor())
                                .environmentObject(viewModel)

                                .onAppear {
                                    viewModel.currentNote = note
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
            if !viewModel.checkIsNoteToDay(notes: cachedNotes) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                      
                        Button {
                            DispatchQueue.main.async {
                                
//                                viewModel.isEditView = false
                                showingNewNoteView.toggle() // Show the sheet
                            }
                            
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
        .onChange(of: searchText) { oldValue, newValue in
            DispatchQueue.main.async {
                filterNotes()
            }
        }
        .onAppear {
            filterNotes()
                updateNotesInViewModel()

            if cachedNotes.isEmpty {
                  cachedNotes = notes // Cache the notes only once
                  filterNotes() // Update filtered notes based on cached notes
              }
        }
        .onChange(of: searchText) { _, _ in
            filterNotes() // Trigger filtering when search text changes
        }
        .onChange(of: selectedMonth) { _, _ in
            filterNotes() // Trigger filtering when the month changes
        }
        .onChange(of: selectedYear) { _, _ in
            filterNotes() // Trigger filtering when the year changes
        }
        .onChange(of: cachedNotes) { _, _ in
            filterNotes() // Trigger filtering when the notes list changes
        }
    }
    //MARK: - functions
    func deleteNoteAsync(at offsets: IndexSet) {
        DispatchQueue.global(qos: .userInitiated).async {
            for index in offsets {
                let noteToDelete = cachedNotes[index]
                context.delete(noteToDelete)
            }
            DispatchQueue.main.async {
                do {
                    try context.save()
                } catch {
                    print("Error deleting note: \(error.localizedDescription)")
                }
            }
        }
    }
    func filterNotes() {
        filteredNotes = cachedNotes.filter { note in
            let noteMonth = DateFormatter().monthSymbols[Calendar.current.component(.month, from: note.date) - 1]
            let noteYear = "\(Calendar.current.component(.year, from: note.date))"
            let matchesSearch = searchText.isEmpty || note.title.localizedCaseInsensitiveContains(searchText)
            return noteMonth == selectedMonth && noteYear == selectedYear && matchesSearch
        }
    }
   func updateNotesInViewModel() {
       DispatchQueue.main.async {
           viewModel.notes = cachedNotes
       }
    }
    

}



#Preview {
    AddNewNoteView()
        .environmentObject(MainTabViewViewModel())
        .modelContainer(for: Note.self, inMemory: true)
    
}
