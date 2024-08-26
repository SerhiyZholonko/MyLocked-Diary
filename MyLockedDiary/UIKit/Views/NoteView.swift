//
//  NoteView.swift
//  MyLockedDiary
//
//  Created by apple on 18.08.2024.
//

import SwiftUI

struct NoteView: View {
    @Binding var title: String
    @Binding var textNote: String
    var body: some View {
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
                    Text(title)
                }
                Text(textNote)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.clear)
                    .padding()
                    .border(Color.gray, width: 1)
            }
        }  
    }
}

#Preview {
    NoteView(title: .constant("Test"), textNote: .constant("Test"))
}
