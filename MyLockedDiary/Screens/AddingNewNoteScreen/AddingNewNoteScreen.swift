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
    @State var noteTitle: String = ""
    @State var noteText: String = ""
    
    var body: some View {
		VStack(alignment: .leading) {
            Group {
                TextField("Enter title", text: $noteTitle)
					TransparentTextEditor(text: $noteText)
						.frame(height: 150)
						.background(Color.secondary.opacity(0.3))
						.cornerRadius(8)
				
               
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
                .disabled(noteTitle.isEmpty || noteText.isEmpty)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
			AddNoteBottomView()
				.padding(.leading)
            Spacer()
        }
        .toolbar {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .background(viewModel.getThemeBackgroundColor())
        .navigationTitle("Adding new note")
    }
}

#Preview {
    NavigationStack {
        AddingNewNoteScreen()
            .environmentObject(MainTabViewViewModel())
    }
}
