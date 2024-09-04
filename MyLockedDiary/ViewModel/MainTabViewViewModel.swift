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
    @Published var selectedFontColor: FontColor? = .primary
    @Published var isAddTag: Bool = false
    var selectedFont: UIFont! {
          guard let fontName = selectedFontName?.fontName, let fontSize = selectedFontSize?.fontValue else {
              return UIFont(name: ".SFUIText", size: 14)!
          }
          return UIFont(name: fontName, size: fontSize)
      }
    @Published var tags: [String] = ["tag1", "tag2","tag3", "tag4"]
    @Published var showDeleteButton: [String: Bool] = [:]
    @Published var selectedTags: [String] = []

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
    
    //Add tag
    func addNewTag(_ newTag: String) {
        tags.append(newTag)
    }
    func addTagToSelected(_ tag: String) {
        selectedTags.append(tag)
    }
    
}
