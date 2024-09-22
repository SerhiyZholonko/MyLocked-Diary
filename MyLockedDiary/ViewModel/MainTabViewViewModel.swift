//
//  MainTabViewViewModel.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI


struct EnergyItem: Identifiable {
    let id = UUID()  // Add unique identifier
    let color: Color
    let name: String
    let sfSymbol: String
}
struct FeelingItem: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
}
class MainTabViewViewModel: ObservableObject {
    @Published var isEditView: Bool = false

    @Published var noteTitle: String = ""
    @Published var noteText: String = ""
    @Published var currentEmoji: String = ""
    @Published var date =  Date.now
    
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
//    @Published var selectedTags: Set<String> = []

    @Published var selectedTags: [String] = []

    let energyColors: [EnergyItem] = [
        EnergyItem(color: .blue, name: "Calm", sfSymbol: "tortoise"),
        EnergyItem(color: .red, name: "Passion", sfSymbol: "flame.fill"),
        EnergyItem(color: .green, name: "Growth", sfSymbol: "leaf.fill"),
        EnergyItem(color: .orange, name: "Enthusiasm", sfSymbol: "sun.max.fill"),
        EnergyItem(color: .purple, name: "Creativity", sfSymbol: "paintbrush.fill"),
        EnergyItem(color: .yellow, name: "Happiness", sfSymbol: "star.fill"),
        EnergyItem(color: .pink, name: "Love", sfSymbol: "heart.fill"),
        EnergyItem(color: .gray, name: "Neutral", sfSymbol: "cloud.fill"),
        EnergyItem(color: .brown, name: "Stability", sfSymbol: "house.fill"),
        EnergyItem(color: .cyan, name: "Freshness", sfSymbol: "drop.fill")
    ]

    let feelings: [FeelingItem] = [
        FeelingItem(emoji: "😊", name: "Happy"),
        FeelingItem(emoji: "😔", name: "Sad"),
        FeelingItem(emoji: "😡", name: "Angry"),
        FeelingItem(emoji: "😴", name: "Tired"),
        FeelingItem(emoji: "😎", name: "Confident"),
        FeelingItem(emoji: "🤔", name: "Thoughtful"),
        FeelingItem(emoji: "😇", name: "Grateful"),
        FeelingItem(emoji: "😬", name: "Nervous"),
        FeelingItem(emoji: "🥳", name: "Excited"),
        FeelingItem(emoji: "😌", name: "Relaxed"),
        FeelingItem(emoji: "😱", name: "Surprised"),
        FeelingItem(emoji: "😕", name: "Confused"),
        FeelingItem(emoji: "🤯", name: "Overwhelmed"),
        FeelingItem(emoji: "🤗", name: "Loved"),
        FeelingItem(emoji: "😤", name: "Frustrated"),
        FeelingItem(emoji: "😭", name: "Heartbroken"),
        FeelingItem(emoji: "😅", name: "Embarrassed"),
        FeelingItem(emoji: "🤩", name: "Amazed"),
        FeelingItem(emoji: "🥶", name: "Cold"),
        FeelingItem(emoji: "🤒", name: "Sick"),
        FeelingItem(emoji: "😇", name: "Blessed"),
        FeelingItem(emoji: "😜", name: "Playful"),
        FeelingItem(emoji: "🤤", name: "Hungry"),
        FeelingItem(emoji: "😷", name: "Unwell")
    ]

    @Published var selectedList: SelectedList = .numbered
    
    @Published var selectedEnergyColor: Color = .blue
    @Published var selectedEnergyImageName: String = ""
    @Published var selectedEmoji: String = ""
    @Published var selectedFeeling: FeelingItem?

    var selectionIndex = 2
    let themeListImage: [ThemeModel] = [ThemeModel(bgImageName: "glacier", color: Color.orangeColors, imageName: "glacier"), ThemeModel(bgImageName:  "tree", color: Color.limeColors, imageName: "tree"), ThemeModel(bgImageName: "fantasy", color: Color.skyColors, imageName: "fantasy")]
    init() {
        selectedEnergyColor = getSelectedColor()
    }
    func updateNode() {
         noteTitle = ""
         noteText = ""
        currentEmoji = ""
        date =  Date.now
        selectedEnergyColor = getSelectedColor()
        selectedEnergyImageName = ""
        selectedEmoji = ""
    }
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
  
    func addTagToSelected(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll{$0 == tag} // Deselect if already selected
        } else {
            selectedTags.append(tag) // Select if not selected
        }
    }

    func getSelectedColorForTag() -> Color {
        return selectedTags.isEmpty ? .blue : .green
    }

    func addNewTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
        }
    }
    
}
