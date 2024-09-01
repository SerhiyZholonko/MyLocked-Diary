//
//  RectangleGridView.swift
//  MyLockedDiary
//
//  Created by apple on 31.08.2024.
//

//RectangleGridView
import SwiftUI

struct SetBackgroundGridView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Environment(\.dismiss) private var dismiss
    let rectangles: [Color] = [.blue, .red, .green, .orange, .purple, .yellow, .pink, .gray, .brown, .cyan]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(rectangles.indices, id: \.self) { index in
                        Rectangle()
                            .fill(rectangles[index])
                            .frame(height: 100)
                            .cornerRadius(10)
                    }
                }
                .padding()

            }
            .toolbar(content: {
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .tint(viewModel.getSelectedColor())

                }

            })
            .background(viewModel.getThemeBackgroundColor())
        }
       
      

        
    }
}

