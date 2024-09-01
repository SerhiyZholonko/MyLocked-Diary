//
//  ImageCollectionView.swift
//  MyLockedDiary
//
//  Created by apple on 31.08.2024.
//

import SwiftUI

struct EmojiCollectionView: View {
    
    var getImageName: (String) -> Void
    let images = ["confused", "cool", "emoji", "sad", "shocked", "smile-2", "smile2", "wow"] // Replace with your image names
    
    let columns = [
        GridItem(.fixed(40)),
        GridItem(.fixed(40)),
        GridItem(.fixed(40))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(images, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8) // Optional: for rounded corners
                    .onTapGesture {
                        getImageName(imageName)
                    }
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
