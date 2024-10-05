//
//  SwiftUIView.swift
//  MyLockedDiary
//
//  Created by apple on 21.09.2024.
//

import SwiftUI

struct SingleNodeView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel

    private let note: Note
    private let dividerColor: Color
    private let emojiBgColor: Color
    init(note: Note, dividerColor: Color, emojiBgColor: Color) {
        self.note = note
        self.dividerColor = dividerColor
        self.emojiBgColor = emojiBgColor
    }
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(note.date.toString())
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.leading, 16)
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.fromHex( note.energyColor) )
                        Image(systemName: note.energyImageName)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 40, height: 40)
                    ZStack {
                        Circle()
                            .fill(emojiBgColor)
                        Text(note.emoji)
                           
                    }
                        .frame(width: 40, height: 40)
                }
                .frame(height: 60)
                Divider()
                HStack {
                    Text("Title")
                        .font(.caption)
                        .padding(.horizontal, 30)
                    Text(note.title)
                }
              
                Divider()

                Text(note.noteText)
//                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color.clear)
                    .padding()
                if let imageData = note.imagesData?.first, // Unwrap the optional Data
                   let image = UIImage(data: imageData) {   // Create UIImage from Data
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
//                    .border(Color.gray, width: 1)
                Rectangle()
                    .fill(dividerColor)  // Set your desired color
                     .frame(height: 3)  // Set the thickness
              
            }
            .font(Font(viewModel.selectedFont))
            .foregroundColor(viewModel.selectedFontColor?.color)

        }
       
    }
}

#Preview {
    SingleNodeView(note: Note(title: "title", noteText: "Some text", date: Date(), energyColor: .red, energyImageName: "String",
                              emoji: "String"), dividerColor: .red, emojiBgColor: .blue)
        .background(.orange)
}
