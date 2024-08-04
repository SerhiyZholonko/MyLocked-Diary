//
//  MainTabViewViewModel.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI


class MainTabViewViewModel: ObservableObject {
    var selectionIndex = 0
    let themeListImage: [ThemeModel] = [ThemeModel(bgImageName: "glacier", color: Color.orangeColors, imageName: "glacier"), ThemeModel(bgImageName:  "tree", color: Color.limeColors, imageName: "tree"), ThemeModel(bgImageName: "fantasy", color: Color.skyColors, imageName: "fantasy")]
    func getThemeBackgroundColor() -> Color {
        themeListImage[selectionIndex].color[1]
    }
    func getTintColor() -> Color {
        themeListImage[selectionIndex].color[0]

    }
    func getSelectedColor() -> Color {
        themeListImage[selectionIndex].color[3]

    }
}
