//
//  EnergyToDay.swift
//  MyLockedDiary
//
//  Created by apple on 05.09.2024.
//

import SwiftUI

struct EnergyThisDay: View {
        @EnvironmentObject var viewModel: MainTabViewViewModel
        @Environment(\.dismiss) private var dismiss
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        var body: some View {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.energyColors.indices, id: \.self) { index in
                            let item = viewModel.energyColors[index]
                            VStack{
                                ZStack {
                                    Rectangle()
                                        .fill(item.color)
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            viewModel.selectedEnergy = item.color
                                        }
                                    Image(systemName: item.sfSymbol)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.white)
                                }
                                Text(item.name)
                                    .font(.system(size: 16))
                            }
                           
                           
                        }
                    }
                    .padding()

                }
                .toolbar(content: {
                    Button {
                        dismiss()
                        
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .tint(viewModel.getSelectedColor())

                    }

                })
                .background(viewModel.getThemeBackgroundColor())
                .navigationTitle("How energetic was your day?")
                .navigationBarTitleDisplayMode(.inline)
            }
           
          

            
            }
}

#Preview {
    EnergyThisDay()
}
