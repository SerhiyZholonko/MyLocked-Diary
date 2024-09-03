//
//  MainTabViewViewModel.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI


class MainTabViewViewModel: ObservableObject {
    @Published var selectedFontName: FontName? = .default
    @Published var selectedFontSize: FontSize? = .h3
        
    
    var selectedFont: UIFont! {
          guard let fontName = selectedFontName?.fontName, let fontSize = selectedFontSize?.fontValue else {
              return UIFont(name: ".SFUIText", size: 14)!
          }
          return UIFont(name: fontName, size: fontSize)
      }
      
    var selectionIndex = 2
    let themeListImage: [ThemeModel] = [ThemeModel(bgImageName: "glacier", color: Color.orangeColors, imageName: "glacier"), ThemeModel(bgImageName:  "tree", color: Color.limeColors, imageName: "tree"), ThemeModel(bgImageName: "fantasy", color: Color.skyColors, imageName: "fantasy")]
    func getThemeBackgroundColor() -> Color {
        themeListImage[selectionIndex].color[1]
    }
    func getTintColor() -> Color {
        themeListImage[selectionIndex].color[0]

    }
    func getHeaderImageName() -> String {
        themeListImage[selectionIndex].imageName
    }
    func getSelectedColor() -> Color {
        themeListImage[selectionIndex].color[3]

    }
    
}
