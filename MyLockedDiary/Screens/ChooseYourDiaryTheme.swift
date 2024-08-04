//
//  ChooseYourDiaryTheme.swift
//  MyLockedDiary
//
//  Created by apple on 29.07.2024.
//

import SwiftUI
struct ChooseYourDiaryThemeViewModel {
    let themeListImage: [ThemeModel] = [ThemeModel(bgImageName: "glacier", color: Color.orangeColors, imageName: "glacier"), ThemeModel(bgImageName:  "tree", color: Color.limeColors, imageName: "tree"), ThemeModel(bgImageName: "fantasy", color: Color.skyColors, imageName: "fantasy")]
}
struct ChooseYourDiaryTheme: View {
    @State var viewModel = ChooseYourDiaryThemeViewModel()
    @State private var selectedThemeIndex = 0 // Track the current tab index

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.gray
                        .edgesIgnoringSafeArea(.all)
                    
                    TabView(selection: $selectedThemeIndex) { // Bind selection to the state variable
                        ForEach(viewModel.themeListImage.indices, id: \.self) { index in
                            let theme = viewModel.themeListImage[index]

                            ZStack {
                                Rectangle()
                                    .fill(theme.color[1])
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.7)

                                VStack(spacing: 0) {
                                    Image(theme.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(
                                            width: geometry.size.width * 0.8,
                                            height: 100,
                                            alignment: .top
                                        )
                                        .clipped()

                                    Rectangle()
                                        .fill(theme.color[0])
                                        .frame(height: 5)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                .padding()

                                VStack {
                                    HStack {
                                        Image("time")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(theme.color[0])
                                        Spacer()

                                        ZStack(alignment: .bottomTrailing) {
                                            Image("note")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(theme.color[0])
                                            Image(systemName: "plus.circle.fill")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .foregroundColor(theme.color[3])
                                        }
                                        .frame(width: 50, height: 50)
                                        Spacer()
                                        Image("user")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(theme.color[0])
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                .padding()
                            }
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.7)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                            .tag(index) // Set the tag to keep track of the index
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .navigationTitle("Choose Your Diary Theme")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            HStack(spacing: 40) {
                Button {
                    // Add action for the "Back" button
                } label: {
                    Text("Back")
                        .foregroundStyle(.white)
                        .frame(width: 150)
                        .padding(.vertical)
                        .background(Color.sky4)
                        .cornerRadius(20)
                }
                Button {
                    // Add action for the "Select" button
                } label: {
                    Text("Select")
                        .foregroundStyle(.white)
                        .frame(width: 150)
                        .padding(.vertical)
                        .background(viewModel.themeListImage[selectedThemeIndex].color[1]) // Use the color from the current theme
                        .cornerRadius(20)
                }
            }
            .padding()
        }
    }
}







#Preview {
    ChooseYourDiaryTheme()
}
