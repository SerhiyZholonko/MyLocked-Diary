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
    let columns = [GridItem(.flexible())]
    
    @State private var currentDetent: PresentationDetent = .fraction(1.0)
    
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
                        ZStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("12.08.2024")
                                        .font(.body)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Title")
                                        .font(.caption)
                                        .padding(.horizontal, 30)
                                    Text(note.title)
                                }
                                Text(note.noteText)
                                    .frame(width: UIScreen.main.bounds.width)
                                    .background(Color.clear)
                                    .padding()
                                    .border(Color.gray, width: 1)
                            }
                        }
                        .background(viewModel.getThemeBackgroundColor())
                        .listRowInsets(EdgeInsets()) // Remove spacing between cells
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
                .background(viewModel.getThemeBackgroundColor())
                
                Spacer()
            }
            .background(viewModel.getThemeBackgroundColor())
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
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
            context.delete(noteToDelete)
            
            
        }
    }
}



#Preview {
    AddNewNoteView()
        .environmentObject(MainTabViewViewModel())
        .modelContainer(for: Note.self, inMemory: true)
    
}
